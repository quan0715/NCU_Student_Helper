import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ncu_helper/model/user_model.dart';
import 'package:ncu_helper/utils/server_config.dart';
import 'package:http/http.dart' as http;

class HSRUserEntity {
  String personId;
  String email;
  String phone;
  HSRUserEntity({
    required this.personId,
    required this.email,
    required this.phone,
  });
  static HSRUserEntity fromJson(Map<String, dynamic> json) {
    return HSRUserEntity(
      personId: json['id_card_number'],
      email: json['email'],
      phone: json['phone'],
    );
  }
  factory HSRUserEntity.defaultData(){
    return HSRUserEntity(
      personId: "",
      email: "",
      phone: "",
    );
  }
}

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

class SchedulingDataEntity {
  bool isAutoUpdate;
  int schedulingTime;
  SchedulingDataEntity({
    required this.isAutoUpdate,
    required this.schedulingTime,
  });
  static SchedulingDataEntity fromJson(Map<String, dynamic> json) {
    return SchedulingDataEntity(
      isAutoUpdate: json['is_auto_update'],
      schedulingTime: json['scheduling_time'],
    );
  }

  factory SchedulingDataEntity.defaultData(){
    return SchedulingDataEntity(
      isAutoUpdate: false,
      schedulingTime: 10,
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

  Future<bool> checkServerConnection(){
    debugPrint("check server connection");
    try{
      return http.Client().get(Uri.parse("${ServerConfig.serverBaseURL}/eeclass_api/check_connection")).then((response) {
        if(response.statusCode == 200){
          return true;
        }
        return false;
      });
    }
    catch(e){
      debugPrint(e.toString());
      return Future.value(false);
    }
  }


  // Future<EECLASSAccountEntity?> getUserEeclassAccount(String lineUserId) async {
  //   debugPrint("lineUserId: $lineUserId");
  //   try{
  //     var result = await http.Client().get(
  //       Uri.parse("${ServerConfig.serverBaseURL}/eeclass_api/get_account_password?user_id=$lineUserId",),
  //       headers: {
  //         'ngrok-skip-browser-warning' : '8000',
  //       }
  //     );
  //     if(result.statusCode == 200){
  //       debugPrint(result.body);
  //       var data = jsonDecode(result.body);
  //       // debugPrint(data.toString());
  //       return EECLASSAccountEntity.fromJson(data);
  //       // return UserModel.fromJson(data);
  //     }
  //     else if(result.statusCode == 404){
  //       debugPrint("user not found");
  //       return null;
  //     }
  //   } catch(e){
  //     debugPrint(e.toString());
  //     throw Exception("get user unknown error ${e.toString()}");
  //   } 
  // }

  Future<bool> eeclassLoginValidation({required String lineUserId, required String account, required String password}) async {
    try{
      var result = await http.Client().post(
        Uri.parse("${ServerConfig.serverBaseURL}/eeclass_api/check_login"),
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

  // Future<NotionDataEntity?> getUserNotionData(String lineUserId) async {
  //   debugPrint("lineUserId: $lineUserId");
  //   try{
  //     var result = await http.Client().get(
  //       Uri.parse("${ServerConfig.serverBaseURL}/eeclass_api/get_notion_oauth_data?user_id=$lineUserId"),
  //       headers: {
  //         'ngrok-skip-browser-warning' : '8000',
  //       }
  //     );
  //     if(result.statusCode == 200){
  //       debugPrint(result.body);
  //       var data = jsonDecode(result.body);
  //       return NotionDataEntity.fromJson(data);
  //     }
  //     else if(result.statusCode == 404){
  //       debugPrint("user not found");
  //       return null;
  //     }
  //   } catch(e){
  //     debugPrint(e.toString());
  //     throw Exception("get user unknown error ${e.toString()}");
  //   } 
  // }

  Future<UserModel?> getUserData(String lineUserId) async {
    debugPrint("lineUserId: $lineUserId");
    try{
      // await FlutterLineLiff().ready;
      // var lineProfile = await FlutterLineLiff().profile;
      var result = await http.Client().get(
        Uri.parse("${ServerConfig.serverBaseURL}/eeclass_api/get_data?user_id=$lineUserId"),
        headers: {
          'ngrok-skip-browser-warning' : '8000',
        }
      );
      if(result.statusCode == 200){
        debugPrint(result.body);
        var data = jsonDecode(result.body);
        return UserModel(
          eeclassPassword: data['eeclass_password'],
          eeclassAccount: data['eeclass_account'],
          notionAuthToken: data['notion_token'],
          notionDatabaseId: data['notion_template_id'],
        );
      }
      else if(result.statusCode == 404){
        debugPrint("user not found");
        return null;
      }
    } catch(e){
      debugPrint(e.toString());
      throw Exception("get user unknown error ${e.toString()}");
    }
    return null; 
  }
  
  Future<SchedulingDataEntity> getSchedulingData(String lineUserId) async {
    // debugPrint("get scheduling data from lineUserId: $lineUserId");
    try{
      var result = await http.Client().get(
        Uri.parse("${ServerConfig.serverBaseURL}/scheduling/api/get_data?user_id=$lineUserId"),
        headers: {
          'ngrok-skip-browser-warning' : '8000',
        }
      );
      if(result.statusCode == 200){
        debugPrint(result.body);
        var data = jsonDecode(result.body);
        return SchedulingDataEntity.fromJson(data);
      }
      else if(result.statusCode == 404){
        debugPrint("data not found");
        return SchedulingDataEntity.defaultData();
      }
    } catch(e){
      debugPrint(e.toString());
      throw Exception("get scheduling data unknown error ${e.toString()}");
    }
    return SchedulingDataEntity.defaultData();
  }
  Future<HSRUserEntity> getHSRData(String lineUserId) async {
    // debugPrint("get scheduling data from lineUserId: $lineUserId");
    // try{
    //   var result = await http.Client().get(
    //     Uri.parse("${ServerConfig.serverBaseURL}/scheduling/api/get_data?user_id=$lineUserId"),
    //     headers: {
    //       'ngrok-skip-browser-warning' : '8000',
    //     }
    //   );
    //   if(result.statusCode == 200){
    //     debugPrint(result.body);
    //     var data = jsonDecode(result.body);
    //     return HSRUserEntity.fromJson(data);
    //   }
    //   else if(result.statusCode == 404){
    //     debugPrint("data not found");
    //     return HSRUserEntity.defaultData();
    //   }
    // } catch(e){
    //   debugPrint(e.toString());
    //   throw Exception("get scheduling data unknown error ${e.toString()}");
    // }
    return HSRUserEntity.defaultData();
  }

  Future<bool> updateSchedulingData({required String lineUserId,required SchedulingDataEntity entity}) async {
    try{
      var result = await http.Client().post(
        Uri.parse("${ServerConfig.serverBaseURL}/scheduling/api/update"),
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({
          "scheduling_time": entity.schedulingTime,
          "is_auto_update": entity.isAutoUpdate,
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
}

