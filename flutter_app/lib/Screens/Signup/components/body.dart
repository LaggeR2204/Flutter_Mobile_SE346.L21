import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Login/Login.dart';
import 'package:flutter_app/Screens/Signup/SignUp.dart';
import 'package:flutter_app/components/RoundedButton.dart';
import 'package:flutter_app/components/RoundedPasswordFeild.dart';
import 'package:flutter_app/components/RoundedTextField.dart';
import 'package:flutter_app/components/TextFieldContainer.dart';
import 'package:flutter_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

final ref = FirebaseFirestore.instance.collection('users');

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  "Let's Get Started!",
                  style: TextStyle(
                      fontSize: size.height * 0.05, color: Colors.black),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextFieldContainer(
                  child: RoundedTextField(
                    icon: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                  ),
                ),
                TextFieldContainer(
                  child: RoundedTextField(
                    icon: Icons.person,
                    controller: usernameController,
                    hintText: "Username",
                  ),
                ),
                TextFieldContainer(
                  child: RoundedPasswordField(
                    hintText: "Password",
                    controller: passwordController,
                  ),
                ),
                TextFieldContainer(
                  child: RoundedPasswordField(
                    hintText: "Repeat Password",
                    controller: repeatPasswordController,
                  ),
                ),
                RoundedButton(
                  text: "SIGN UP",
                  press: () {
                    if (isEmpty()) {
                      Fluttertoast.showToast(msg: "Please enter all fields");
                    } else if (repeatPasswordController.value.text !=
                        passwordController.value.text) {
                      Fluttertoast.showToast(msg: "Passwords do not match");
                      passwordController.clear();
                      repeatPasswordController.clear();
                    } else {
                      signUp(context);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ));
                      },
                      child: Text(
                        "Login here",
                        style: TextStyle(color: appPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController repeatPasswordController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp(BuildContext context) {
    RegisterWithFirebase(context, emailController.value.text,
        usernameController.value.text, passwordController.value.text);
  }

  bool isEmpty() {
    if (emailController.value.text != "" &&
        usernameController.value.text != "" &&
        passwordController.value.text != "" &&
        repeatPasswordController.value.text != "") {
      return false;
    }
    return true;
  }

  void RegisterWithFirebase(BuildContext context, String _email,
      String _username, String _password) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
              email: _email, password: _password))
          .user;
      try {
        user.sendEmailVerification();
      } catch (e) {}

      addUserInfoToStorage(user);

      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("ERROR!!!"),
          content: new Text("Sign up success, verify your email before login"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(color: appPrimaryColor),
              ),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              },
            )
          ],
        ),
      );
    } catch (error) {
      if (error.code == "invalid-email") {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("ERROR!!!"),
            content: new Text("Invalid email"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: appPrimaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        repeatPasswordController.clear();
      } else if (error.code == "email-already-in-use") {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("ERROR!!!"),
            content: new Text("Email already in use"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: appPrimaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        repeatPasswordController.clear();
      } else if (error.code == "weak_password") {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("ERROR!!!"),
            content: new Text("Your password is too weak"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: appPrimaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
        passwordController.clear();
        repeatPasswordController.clear();
      } else {
        print("[SIGNUP ERROR] " + error.code);
      }
    }
  }

  Future<void> addUserInfoToStorage(User user) async {
    String userName = usernameController.text;

    if (userName != null || userName.length != 0) {
      ref.doc(user.uid).set({
        "id": user.uid,
        "photoUrl":
            "", //FirebaseStorage.instance.ref().child("defaultProfileImage.png"),
        "email": user.email,
        "displayName": userName,
        "bio": "",
        "followers": {},
        "following": {},
        "chatWiths": {},
        "searchRecent": []
      });
    }
  }
}
