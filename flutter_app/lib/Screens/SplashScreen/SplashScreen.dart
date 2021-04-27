// import 'package:flutter/material.dart';

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       decoration: new BoxDecoration(
//         gradient: new LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           stops: [0.1, 0.9],
//           colors: [
//             Color(0xFFFC5C7D),
//             Color(0xFF6A82FB),
//           ],
//         ),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 90.0),
//       child: Image.asset(
//         "assets/images/AppLogo.png",
//         fit: BoxFit.scaleDown,
//       ),
//     );
//   }

//   void goToNextScreen(bool shouldLogin) {
//     if (shouldLogin) {
//       Navigator.pushReplacementNamed(context, routeName)
//     } else {
//       Navigator.pushReplacementNamed(context, );
//     }
//   }
// }