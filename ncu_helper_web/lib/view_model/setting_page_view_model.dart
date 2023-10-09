
import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/model/user_model.dart';

class SettingPageViewModel extends ChangeNotifier{

  UserModel user = UserModel();
  bool _isLoading = false;
  
  set isLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void setStudentId(String studentId){
    user.studentId = studentId;
    notifyListeners();
  }

  void setEeclassPassword(String eeclassPassword){
    user.eeclassPassword = eeclassPassword;
    notifyListeners();
  }

  void setLineUserId(String lineUserId){
    user.lineUserId = lineUserId;
    notifyListeners();
  }

  bool get checkAccountValidated => user.accountValidated();

  void lineLogin() async{
    isLoading = true;
    FlutterLineLiff().login(
      config: LoginConfig(  
        redirectUri: 'https://3cf0-36-224-82-202.ngrok-free.app',
      ),
    );
    isLoading = false;
  }

  Future<void> init() async{
    isLoading = true;
    await FlutterLineLiff().ready;
    isLoading = false;
  }

}