
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ncu_helper/repositories/user_repository.dart';
import 'package:ncu_helper/utils/server_config.dart';

class SettingPageViewModel extends ChangeNotifier{
  FlutterLineLiff liff = FlutterLineLiff();
  UserModel user = UserModel();
  String get lineUserName => user.lineUserName.isEmpty ? "尚未登入" : user.lineUserName;
  String get lineId => user.lineUserId.isEmpty ? "尚未登入" : user.lineUserId;
  bool _isLoading = false;
  bool _isEEclassConnectionSuccess = false;

  bool get isEEclassConnectionSuccess => _isEEclassConnectionSuccess;
  bool get isLineLoggedIn => liff.isLoggedIn;  
  
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
        redirectUri: ServerConfig.redirectURL
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
    if(isLineLoggedIn && user.lineUserId.isNotEmpty){
      var result = await UserRepository().getUser(user.lineUserId);
      if(result != null){
        debugPrint("account: ${result.accountName}, password: ${result.accountPassword}");
        setStudentId(result.accountName);
        setEEclassPassword(result.accountPassword);
        await eeclassConnectionTest();
      }
    }
    else{
      debugPrint("line not logged in can't fetch user");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> userInitTest() async{
    isLoading = true;
    notifyListeners();
    // if(isLineLoggedIn && user.lineUserId.isNotEmpty){
    var result = await UserRepository().getUser("U91c210fcea0952e4856265ea5f09571f");
    if(result != null){
      debugPrint("account: ${result.accountName}, password: ${result.accountPassword}");
      setStudentId(result.accountName);
      setEEclassPassword(result.accountPassword);
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
  

  Future<void> init() async{
    _isLoading = true;
    notifyListeners();
    await liff.ready;
    await updateLineInfo();
    debugPrint('liff is ready, isLogin: ${liff.isLoggedIn}'); 
    await userInit();
    _isLoading = false;
    notifyListeners();
  }

}