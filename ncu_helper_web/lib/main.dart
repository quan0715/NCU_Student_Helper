import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/utils/server_config.dart';
import 'package:ncu_helper/view/home_page/home_page_view.dart';
import 'package:ncu_helper/view/setting_page/oauth_redirect_page.dart';
import 'package:ncu_helper/view/setting_page/setting_page_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLineLiff().init(
    config: Config(liffId: ServerConfig.liffId),
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
      title: 'NCU STUDENT HELPER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomePageView(),
      routes: {
        '': (context) => const HomePageView(), // This is the default route.
        '/setting': (context) => const SettingPageView(),
        '/notion/auth_page':(context) => const OauthRedirectPage(),
      }
    );
  }
}
