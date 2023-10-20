
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ncu_helper/repositories/user_repository.dart';
import 'package:ncu_helper/utils/server_config.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPageViewModel extends ChangeNotifier{
  FlutterLineLiff liff = FlutterLineLiff();
  UserModel user = UserModel();
  String get lineUserName => user.lineUserName.isEmpty ? "尚未登入" : user.lineUserName;
  String get lineId => user.lineUserId.isEmpty ? "尚未登入" : user.lineUserId;
  String get studentId => user.studentId.isEmpty ? "None" : user.studentId;
  String get eeclassPassword => user.eeclassPassword.isEmpty ? "None" : user.eeclassPassword;
  String get notionAuthToken => user.notionAuthToken.isEmpty ? "None" : user.notionAuthToken;
  String get notionTemplateId => user.notionDatabaseId.isEmpty ? "None" : user.notionDatabaseId;

  bool _isLoading = false;
  bool _isEEclassConnectionSuccess = false;
  // TODO: will be move to Entity
  bool _isSchedulingModeOpen = false;
  List<int> schedulingTimeOptions = [10, 20 , 30, 60,];
  int _schedulingTimeOptionValue = 10;
  int get schedulingTimeOption => _schedulingTimeOptionValue;
  bool get isEEclassConnectionSuccess => _isEEclassConnectionSuccess;
  bool get isLineLoggedIn => liff.isLoggedIn;  
  bool get isNotionAuthSuccess => user.notionAuthToken.isNotEmpty && user.notionDatabaseId.isNotEmpty;
  bool get isSchedulingModeOpen => _isSchedulingModeOpen;

  set isSchedulingModeOpen(bool isSchedulingModeOpen){
    _isSchedulingModeOpen = isSchedulingModeOpen;
    notifyListeners();
  }

  set schedulingTimeOption(int schedulingTimeOption){
    _schedulingTimeOptionValue = schedulingTimeOption;
    notifyListeners();
  }
  
  set isLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void setStudentId(String studentId){
    user.studentId = studentId;
    // notifyListeners();
  }

  void setEEclassPassword(String eeclassPassword){
    user.eeclassPassword = eeclassPassword;
    // notifyListeners();
  }

  void setNotionAuthToken(String notionAuthToken){
    user.notionAuthToken = notionAuthToken;
    // notifyListeners();
  }

  void setNotionTemplateId(String notionTemplateId){
    user.notionDatabaseId  = notionTemplateId;
    // notifyListeners();
  }

  void setLineUserId(String lineUserId){
    user.lineUserId = lineUserId;
    notifyListeners();
  }

  void setLineUserName(String lineUserName){
    user.lineUserName = lineUserName;
    notifyListeners();
  }
  
  Future<void> updateLineInfo () async {
    isLoading = true;
    notifyListeners();
    if(isLineLoggedIn){
      var profile = await liff.profile ;
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

  Future<void> lineLogin() async{
    isLoading = true;
    notifyListeners();
    liff.login(
      config: LoginConfig(  
        redirectUri: ServerConfig.hostBaseUrl
      ),
    );
    isLoading = false;
    notifyListeners();
    await updateLineInfo();
    await userInit();
  }

  Future<void> userInit() async{
    isLoading = true;
    notifyListeners();
    try{
      if(isLineLoggedIn && user.lineUserId.isNotEmpty){
        var result = await UserRepository().getUserEeclassAccount(user.lineUserId);
        if(result != null){
          debugPrint("account: ${result.accountName}, password: ${result.accountPassword}");
          setStudentId(result.accountName);
          setEEclassPassword(result.accountPassword);
          await eeclassConnectionTest();
        }
        var notionData = await UserRepository().getUserNotionData(user.lineUserId);
        if(notionData != null){
          debugPrint("authToken: ${notionData.authToken}, copyTemplateIndex: ${notionData.copyTemplateIndex}");
          setNotionAuthToken(notionData.authToken);
          setNotionTemplateId(notionData.copyTemplateIndex);
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

  Future<void> userInitTest() async{
    isLoading = true;
    notifyListeners();
    // if(isLineLoggedIn && user.lineUserId.isNotEmpty){
    var eeclassAccount = await UserRepository().getUserEeclassAccount("U9bb9c1cdc6beb4cd5dd4f871602a6b8b");

    if(eeclassAccount != null){
      debugPrint("account: ${eeclassAccount.accountName}, password: ${eeclassAccount.accountPassword}");
      setStudentId(eeclassAccount.accountName);
      setEEclassPassword(eeclassAccount.accountPassword);
    }
    else{
      debugPrint("line not logged in can't fetch user");
    }
    var notionData = await UserRepository().getUserNotionData("U9bb9c1cdc6beb4cd5dd4f871602a6b8b");
    if(notionData != null){
      debugPrint("authToken: ${notionData.authToken}, copyTemplateIndex: ${notionData.copyTemplateIndex}");
      setNotionAuthToken(notionData.authToken);
      setNotionTemplateId(notionData.copyTemplateIndex);
    }
    else{
      debugPrint("line not logged in can't fetch user");
    }
    isLoading = false;
    notifyListeners();
  }


  Future<void> eeclassConnectionTest() async{
    isLoading = true;
    notifyListeners();
    debugPrint("eeclassConnectionTest");
    debugPrint("account: ${user.studentId}, password: ${user.eeclassPassword}, lineUserId: ${user.lineUserId}");
    // String linUserId = "U91c210fcea0952e4856265ea5f09571f";
    if(isLineLoggedIn && user.lineUserId.isNotEmpty){
      final result = await UserRepository().eeclassLoginValidation(
        account: user.studentId,
        password: user.eeclassPassword,
        lineUserId: user.lineUserId
        // lineUserId: "U91c210fcea0952e4856265ea5f09571f"
      );
    
      _isEEclassConnectionSuccess = result;
      debugPrint(_isEEclassConnectionSuccess.toString());
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

  Future<void> launchNotionOAuthTest() async {
    String linUserId = "U9bb9c1cdc6beb4cd5dd4f871602a6b8b";
    if (!await launchUrl(
      // Uri.parse(ServerConfig.notionAuthURL),
      Uri.parse(ServerConfig.serverBaseURL + "/notion/auth?user_id=$linUserId"),
      mode: LaunchMode.externalApplication,
      // webOnlyWindowName: '_blank'
      // webOnlyWindowName: '_self'
    )) {
      throw Exception('Could not launch notionAuth');
    }
  }

  

  Future<void> init() async{
    _isLoading = true;
    notifyListeners();
    debugPrint('liff is ready, isLogin: ${liff.isLoggedIn}'); 
    // await liff.ready;
    await updateLineInfo();
    await userInit();
    // await userInitTest();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> onSchedulingSettingChange() async{
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("update scheduling data");
    try{
      debugPrint("schedulingTimeOption: $schedulingTimeOption , isSchedulingModeOpen: $isSchedulingModeOpen");
    } 
    catch(error){
      debugPrint("onSchedulingSettingChange error ${error.toString()}");
    }
    isLoading = false;
    notifyListeners();
  }

}