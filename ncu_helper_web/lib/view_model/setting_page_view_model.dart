
import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/model/user_model.dart';
import 'package:ncu_helper/repositories/user_repository.dart';
import 'package:ncu_helper/utils/server_config.dart';
import 'package:url_launcher/url_launcher.dart';



class SettingPageViewModel extends ChangeNotifier{
  UserModel user = UserModel();
  HSRUserEntity hsrUser = HSRUserEntity.defaultData();
  SchedulingDataEntity schedulingData = SchedulingDataEntity.defaultData();

  String get lineUserName => user.lineUserName;
  String get lineId => user.lineUserId;
  String get studentId => user.eeclassAccount;
  String get eeclassPassword => user.eeclassPassword;
  String get notionTemplateId => user.notionDatabaseId.isEmpty ? "/" : user.notionDatabaseId;
  String get hsrPersonId => hsrUser.personId;
  String get hsrEmail => hsrUser.email;
  String get hsrPhone => hsrUser.phone;
  bool get isSchedulingModeOpen => schedulingData.isAutoUpdate;
  int get schedulingTimeOption => schedulingData.schedulingTime;
  
  bool get lineLoginChecking => lineId.isNotEmpty && isLineLoggedIn;
  

  Future<void> Function(String)? showLogMessage;
  bool _isLoading = false;
  bool _isEEclassConnectionSuccess = false;
  List<int> schedulingTimeOptions = [10, 20 , 30, 60,];
  List<String> pageTitles = ["EECLASS", "Notion", "高鐵訂票"];
  int _currentPageIndex = 0;
  List<String> messageQueue = [];

  bool isCurrentPageIndex(int index) => _currentPageIndex == index;
  int get currentPageIndex => _currentPageIndex;
  bool get isLoading => _isLoading;
  bool get isEEclassConnectionSuccess => _isEEclassConnectionSuccess;
  bool get isLineLoggedIn => FlutterLineLiff().isLoggedIn;  
  bool get isNotionAuthSuccess => user.notionAuthToken.isNotEmpty || user.notionDatabaseId.isNotEmpty;

  set currentPageIndex(int currentPageIndex){
    _currentPageIndex = currentPageIndex;
    notifyListeners();
  }
  
  set isSchedulingModeOpen(bool isSchedulingModeOpen){
    schedulingData.isAutoUpdate = isSchedulingModeOpen;
    notifyListeners();
  }

  set schedulingTimeOption(int schedulingTimeOption){
    schedulingData.schedulingTime = schedulingTimeOption;
    notifyListeners();
  }
  
  set isLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void setEeclassAccount(String studentId){
    user.eeclassAccount = studentId;
    // notifyListeners();
  }

  void setEEclassPassword(String eeclassPassword){
    user.eeclassPassword = eeclassPassword;
    // notifyListeners();
  }

  void setNotionTemplateId(String notionTemplateId){
    user.notionDatabaseId  = notionTemplateId;
    notifyListeners();
  }

  void setHsrData({String? hsrPersonId, String? hsrEmail, String? hsrPhone}){
    hsrUser.personId = hsrPersonId ?? hsrUser.personId;
    hsrUser.email = hsrEmail ?? hsrUser.email;
    hsrUser.phone = hsrPhone ?? hsrUser.phone;
  }
  
  void setLineUserId(String lineUserId){
    user.lineUserId = lineUserId;
    notifyListeners();
  }

  void setLineUserName(String lineUserName){
    user.lineUserName = lineUserName;
    notifyListeners();
  }
  
  Future<void> updateLineInfo() async {
    isLoading = true;
    notifyListeners();
    if(isLineLoggedIn){
      var profile = await FlutterLineLiff().profile ;
      setLineUserId(profile.userId);
      setLineUserName(profile.displayName);
      user.lineUserName = profile.displayName;

      debugPrint("lineUserName: $lineUserName");
      debugPrint("lineId: $lineId");
    }
    else{
      debugPrint("line not logged in");
    }
    isLoading = false;
    notifyListeners();
  }

  bool get checkAccountValidated => user.accountValidated();

  Future<void> userInit({bool testMode = false}) async{
    isLoading = true;
    notifyListeners();
    try{
      if(testMode || (isLineLoggedIn && user.lineUserId.isNotEmpty)){
        String userId = testMode ? "U9bb9c1cdc6beb4cd5dd4f871602a6b8b" : user.lineUserId;
        var result = await UserRepository().getUserData(userId);
        if(result != null){
          debugPrint("account: ${result.eeclassAccount}, password: ${result.eeclassPassword}");
          debugPrint("authToken: ${result.notionAuthToken }, copyTemplateIndex: ${result.notionDatabaseId}");
          user.notionAuthToken = result.notionAuthToken;
          setNotionTemplateId(result.notionDatabaseId);
          setEeclassAccount(result.eeclassAccount);
          setEEclassPassword(result.eeclassPassword); 
        }
      }
      else{
        debugPrint("line not logged in can't fetch user");
      }
    }
    catch(error){
      debugPrint("userInit error ${error.toString()}");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> eeclassConnectionTest({bool testMode = false}) async{
    isLoading = true;
    notifyListeners();
    debugPrint("eeclassConnectionTest");
    debugPrint("account: ${user.eeclassAccount}, password: ${user.eeclassPassword}, lineUserId: ${user.lineUserId}");
    // String linUserId = "U91c210fcea0952e4856265ea5f09571f";
    if(isLineLoggedIn && user.lineUserId.isNotEmpty){
      final result = await UserRepository().eeclassLoginValidation(
        account: user.eeclassAccount,
        password: user.eeclassPassword,
        lineUserId: testMode ? "U9bb9c1cdc6beb4cd5dd4f871602a6b8b" :user.lineUserId 
      );
      _isEEclassConnectionSuccess = result;
      if (result) {
        await showLogMessage!("EECLASS 登入成功");
      } else {
        await showLogMessage!("EECLASS 登入失敗");
      }
      // debugPrint(_isEEclassConnectionSuccess.toString());
    }
    isLoading = false;
    notifyListeners();
  }
  
  Future<void> launchNotionOAuth() async {
    if(isLineLoggedIn && user.lineUserId.isNotEmpty){
      if (!await launchUrl(
        // Uri.parse(ServerConfig.notionAuthURL),
        Uri.parse("${ServerConfig.serverBaseURL}/notion/auth?user_id=${user.lineUserId}"),
        mode: LaunchMode.externalApplication,
        // webOnlyWindowName: '_blank'
        webOnlyWindowName: '_self'
      )) {
        throw Exception('Could not launch notionAuth');
      }
    }
    else{
      debugPrint("line not logged in can't fetch user");
    }
  }

  Future<void> launchNotionDB() async {
    if(user.notionDatabaseId.isNotEmpty){
      String modifyIndex = user.notionDatabaseId.replaceAll('-', '');
      String targetURL = "https://www.notion.so/${modifyIndex}";   
      if (!await launchUrl(
        Uri.parse(targetURL),
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank'
        // webOnlyWindowName: '_self'
      )) {
        throw Exception('Could not launch notionAuth');
      }
    }
    else{
      await showLogMessage!("請先授權 Notion");
    }
  }

  Future<void> init() async{
    _isLoading = true;
    _currentPageIndex = 0;
    notifyListeners();
    try{
      await FlutterLineLiff().ready;
      debugPrint('liff is ready, isLogin: $isLineLoggedIn'); 
      await updateLineInfo();
      await userInit();
      await eeclassConnectionTest();
      await getSchedulingData();
      await getHSRData();
    }
    catch(error){
      debugPrint(error.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getHSRData() async {
    if(lineLoginChecking){
      var result = await UserRepository().getHSRData(user.lineUserId);
      hsrUser = result;
      // await showLogMessage!("成功更新高鐵資料");
    }
    else{
      debugPrint("line not logged in can't fetch user");
      await showLogMessage!("請先登入 line");
    }
    notifyListeners();
  }

  Future<void> getSchedulingData() async {
    if(!isLineLoggedIn || user.lineUserId.isEmpty){
      await showLogMessage!("請先登入 line");
      return;
    }
    var data = await UserRepository().getSchedulingData(user.lineUserId);
    debugPrint("is auto update: ${data.isAutoUpdate}");
    debugPrint("scheduling time: ${data.schedulingTime}");
    schedulingData = data;
    notifyListeners();
  }

  Future<void> onHSRDataSubmitted() async{
    // print all
    isLoading = true;
    notifyListeners();
    debugPrint("hsrPersonId: $hsrPersonId");
    debugPrint("hsrEmail: $hsrEmail");
    debugPrint("hsrPhone: $hsrPhone");
    debugPrint("update data toServer");
    final result = await UserRepository().updateHSRData(
      lineUserId: user.lineUserId,
      entity: hsrUser
    );
    result 
      ? await showLogMessage!("成功更新高鐵資料")
      : await showLogMessage!("上傳失敗");
    isLoading = false;
    notifyListeners();
  }
  
  Future<void> onSchedulingSettingChange() async{
    isLoading = true;
    notifyListeners();
    debugPrint("update scheduling data");
    try{
      debugPrint("schedulingTimeOption: $schedulingTimeOption , isSchedulingModeOpen: $isSchedulingModeOpen");
      if(isLineLoggedIn && user.lineUserId.isNotEmpty){
        var result = await UserRepository().updateSchedulingData(lineUserId: user.lineUserId, entity: SchedulingDataEntity(
          isAutoUpdate: isSchedulingModeOpen,
          schedulingTime: schedulingTimeOption,
        ));
        result
          ? await showLogMessage!("已更新排程 自動更新 $isSchedulingModeOpen, 排程時間 $schedulingTimeOption")
          : await showLogMessage!("上傳失敗");
      }
      else{
        debugPrint("line not logged in can't fetch user");
      }
    } 
    catch(error){
      debugPrint("onSchedulingSettingChange error ${error.toString()}");
    }
    isLoading = false;
    notifyListeners();
  }

}