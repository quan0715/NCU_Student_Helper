import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/repositories/user_repository.dart';
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
      await Future.delayed(const Duration(microseconds: 500));
      loadingMessage = "正在初始化 line init ...";
      await liff.ready;
      notifyListeners();
      await Future.delayed(const Duration(microseconds: 500));
      loadingMessage = "連線 Server ..";
      bool isConnective = await UserRepository().checkServerConnection();
      loadingMessage = 
      isConnective ? "連線成功" : "連線失敗，請重啟Server";
      notifyListeners();
      isLoading = !isConnective;
      notifyListeners();
    }

}
