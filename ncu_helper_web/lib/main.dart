import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import 'package:ncu_helper/utils/server_config.dart';
import 'package:ncu_helper/view/home_page/home_page_view.dart';
import 'package:ncu_helper/view/setting_page/setting_page_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncu_helper/view/theme/color.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLineLiff().init(
    config: Config(liffId: ServerConfig.liffId),
    successCallback: () {
      debugPrint('LIFF init success.');
    },
    errorCallback: (error) {
      debugPrint(
          'LIFF init error: ${error.name}, ${error.message}, ${error.stack}');
    },
  );
  runApp(const MyApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NCU STUDENT HELPER',
        scrollBehavior: AppScrollBehavior(),
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFFFFD464),
            surface: Color(0xFF2E2D2D),
            background: Color(0xFF2E2D2D),
            error: Color(0xFFF44336),
            onPrimary: Color(0xFF2E2D2D),
            onSurface: Colors.white,
            onBackground: Colors.white,
            onError: AppColor.onErrorColor,
            secondary: Color(0xFFE7E7E7),
            onSecondary: Color(0xFF2E2D2D),
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const HomePageView(),
        routes: {
          '': (context) => const HomePageView(), // This is the default route.
          '/setting': (context) => const SettingPageView(),
          // '/notion/auth_page': (context) => const OauthRedirectPage(),
        });
  }
}
