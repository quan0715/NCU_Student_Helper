import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/model/user_model.dart';
import 'package:ncu_helper/utils/server_config.dart';

class HomePageViewModel extends ChangeNotifier {
  FlutterLineLiff liff = FlutterLineLiff();
    bool _isLoading = false;
    String loadingMessage = "Loading...";
    bool get isLineLoggedIn => liff.isLoggedIn;  
    bool get isLoading => _isLoading;
    set isLoading(bool isLoading){
      _isLoading = isLoading;
      notifyListeners();
    }

    Future<bool> checkServerConnection() async{
      // try{
      //   final response = await http.get(Uri.parse('https://ncu-helper-server.herokuapp.com/'));
      //   if(response.statusCode == 200){
      //     return true;
      //   }
      //   return false;
      // }catch(e){
      //   return false;
      // }
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }

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
    }



    Future<void> init() async{
      isLoading = true;
      loadingMessage = "Loading ...";
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      loadingMessage = "正在初始化 line init ...";
      await liff.ready;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      loadingMessage = "正在測試連線穩定度 ...";
      notifyListeners();
      await checkServerConnection();
      isLoading = false;
      notifyListeners();
    }
  // UserModel user = UserModel();
  // final _repository = Repository();

  // List<Photo> _photos = [];
  // List<Photo> get photos => _photos;

  // Future<void> fetchPhotos() async {
  //   _photos = await _repository.fetchPhotos();
  //   notifyListeners();
  // }
}
