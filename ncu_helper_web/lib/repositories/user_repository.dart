import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ncu_helper/model/user_model.dart';
import 'package:ncu_helper/utils/server_config.dart';
import 'package:http/http.dart' as http;

class EECLASSAccountEntity {
  final String accountName;
  final String accountPassword;
  const EECLASSAccountEntity({
    required this.accountName,
    required this.accountPassword,
  });
  static EECLASSAccountEntity fromJson(Map<String, dynamic> json) {
    return EECLASSAccountEntity(
      accountName: json['account'],
      accountPassword: json['password'],
    );
  }
}

class NotionDataEntity {
  final String authToken;
  final String copyTemplateIndex;
  const NotionDataEntity({
    required this.authToken,
    required this.copyTemplateIndex,
  });
  static NotionDataEntity fromJson(Map<String, dynamic> json) {
    return NotionDataEntity(
      authToken: json['access_token'],
      copyTemplateIndex: json['duplicated_template_id'],
    );
  }
}

class UserRepository{
  Future<EECLASSAccountEntity?> getUserEeclassAccount(String lineUserId) async {
    debugPrint("lineUserId: $lineUserId");
    try{
      var result = await http.Client().get(
        Uri.parse("${ServerConfig.baseURL}/eeclass_api/get_account_password?user_id=$lineUserId")
      );
      if(result.statusCode == 200){
        var data = jsonDecode(result.body);
        // debugPrint(data.toString());
        return EECLASSAccountEntity.fromJson(data);
        // return UserModel.fromJson(data);
      }
      else if(result.statusCode == 404){
        debugPrint("user not found");
        return null;
      }
    } catch(e){
      debugPrint(e.toString());
      throw Exception("get user unknown error ${e.toString()}");
    } 
  }

  Future<bool> eeclassLoginValidation({required String lineUserId, required String account, required String password}) async {
    try{
      var result = await http.Client().post(
        Uri.parse("${ServerConfig.baseURL}/eeclass_api/check_login"),
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({
          "account": account,
          "password": password,
          "user_id": lineUserId
        })
      );
      if (result.statusCode == 200){
        return true;
      }
      else if(result.statusCode == 401){
        return false;
      }
      else{
        throw Exception("login validation unknown error ${result.statusCode}");
      }
    }catch(e){
      debugPrint(e.toString());
      throw Exception("login validation unknown error ${e.toString()}");
    }
  }

  Future<NotionDataEntity?> getUserNotionData(String lineUserId) async {
    debugPrint("lineUserId: $lineUserId");
    try{
      var result = await http.Client().get(
        Uri.parse("${ServerConfig.baseURL}/eeclass_api/get_notion_oauth_data?user_id=$lineUserId")
      );
      if(result.statusCode == 200){
        var data = jsonDecode(result.body);
        return NotionDataEntity.fromJson(data);
      }
      else if(result.statusCode == 404){
        debugPrint("user not found");
        return null;
      }
    } catch(e){
      debugPrint(e.toString());
      throw Exception("get user unknown error ${e.toString()}");
    } 
  }
}
