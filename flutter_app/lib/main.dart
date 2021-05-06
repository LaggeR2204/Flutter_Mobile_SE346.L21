import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/HomePage.dart';
import 'package:flutter_app/Screens/Welcome/Welcome.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark
    )
  );
  var user = await FirebaseAuth.instance.currentUser();
  runApp(MyApp2(user != null ? HomePage(): WelcomeScreen()));
}

// ignore: must_be_immutable
class MyApp2 extends StatelessWidget {
  Widget _home;

  MyApp2(Widget home){
    _home = home;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            appPrimaryColor2,
            appPrimaryColor,
          ],
        ),
        image: Image.asset('assets/images/AppLogoWhite.png'),
        photoSize: 70,
        loaderColor: Colors.white,
        loadingText: Text("Loading ...", style: TextStyle(color: Colors.white),),
        seconds: 3,
        title: Text(
          appName,
          style: TextStyle(color: Colors.white, fontSize: 50, fontFamily: 'Billabong'),
        ),
        navigateAfterSeconds: _home,
      ),
    );
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(
//     SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarBrightness: Brightness.dark
//     )
//   );
//   var user = await FirebaseAuth.instance.currentUser();
//   runApp(MyApp(user != null ? HomePage(): WelcomeScreen()));
// }

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