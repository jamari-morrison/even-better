import 'dart:io';

import 'package:even_better/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'fb_services/auth.dart';
import 'screens/wrapper.dart';
import 'models/user.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  print("running program");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 200)
    ..indicatorType = EasyLoadingIndicatorType.fadingCube
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static const appTitle = "Even Better";
  final Map<int, Color> customColors = ({
    50: const Color(0xFF330000),
    100: const Color(0xFF330000),
    200: const Color(0xFF330000),
    300: const Color(0xFF800000),
    400: const Color(0xFF800000),
    500: const Color(0xFF800000),
    600: const Color(0xFFCC1414),
    700: const Color(0xFFCC1414),
    800: const Color(0xFF96084F),
    900: const Color(0xFF96084F)
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null, //required
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: MyApp.appTitle,
        theme: ThemeData(
          //TODO: make a custom color swatch with the rose color palette
          primarySwatch: MaterialColor(0xFF800000, customColors),
        ),
        home: const Wrapper(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        // final isValidHost = host == "3.139.159.105";
        // host varies here. need to validate this somehow??
        return true;
      });
  }
}
