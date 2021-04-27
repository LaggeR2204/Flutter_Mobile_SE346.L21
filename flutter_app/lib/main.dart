import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/HomePage.dart';
import 'package:flutter_app/Screens/Welcome/Welcome.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark
    )
  );
  var user = await FirebaseAuth.instance.currentUser();
  runApp(MyApp(user != null ? HomePage(): WelcomeScreen()));
}

class MyApp extends StatelessWidget {
  Widget _home;

  MyApp(Widget home){
    _home = home;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: appPrimaryColor,
        scaffoldBackgroundColor: appBackgroundLightColor,
      ),
      home: _home,
    );
  }
}