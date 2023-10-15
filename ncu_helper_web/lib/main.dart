import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/view/setting_page/oauth_redirect_page.dart';
import 'package:ncu_helper/view/setting_page/setting_page_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLineLiff().init(
    config: Config(liffId: '2001049604-4ZDQX3MK'),
    successCallback: () {
      debugPrint('LIFF init success.');
    },
    errorCallback: (error) {
      debugPrint('LIFF init error: ${error.name}, ${error.message}, ${error.stack}');
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SettingPageView(),
      routes: {
        '': (context) => const SettingPageView(), // This is the default route.
        '/setting': (context) => const SettingPageView(),
        '/notion/redirect':(context) => const OauthRedirectPage(),
      }
    );
  }
}
