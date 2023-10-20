
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
  String get studentId => user.eeclassAccount.isEmpty ? "None" : user.eeclassAccount;
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
    user.eeclassAccount = studentId;
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
          setNotionAuthToken(result.notionAuthToken);
          setNotionTemplateId(result.notionDatabaseId);
          setStudentId(result.eeclassAccount);
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
    if(testMode || (isLineLoggedIn && user.lineUserId.isNotEmpty)){

      final result = await UserRepository().eeclassLoginValidation(
        account: user.eeclassAccount,
        password: user.eeclassPassword,
        lineUserId: testMode ? "U9bb9c1cdc6beb4cd5dd4f871602a6b8b" :user.lineUserId 
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
    await liff.ready;
    debugPrint('liff is ready, isLogin: ${liff.isLoggedIn}'); 
    await updateLineInfo();
    await userInit();
    await eeclassConnectionTest();
    
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