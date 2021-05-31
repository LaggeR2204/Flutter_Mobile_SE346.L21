import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Login/Login.dart';
import 'package:flutter_app/components/RoundedButton.dart';
import 'package:flutter_app/components/RoundedPasswordFeild.dart';
import 'package:flutter_app/components/RoundedTextField.dart';
import 'package:flutter_app/components/TextFieldContainer.dart';
import 'package:flutter_app/constants.dart';

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
                  SizedBox(height: size.height * 0.05,),
                  Text("Let's Get Started!", style: TextStyle(fontSize: size.height * 0.05, color: Colors.black),),
                  SizedBox(height: size.height * 0.05,),
                  TextFieldContainer(
                    child: RoundedTextField(
                      icon: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedTextField(
                      icon: Icons.person,
                      controller: usernameController,
                      hintText: "Username",
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedPasswordField(
                      hintText: "Password",
                      controller: passwordController,
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedPasswordField(
                      hintText: "Repeat Password",
                      controller: repeatPasswordController,
                      onChanged: (value){},
                    ),
                  ),
                  RoundedButton(
                      text: "SIGN UP",
                      press: () {
                        if(isEmpty()){
                          showDialog(
                            context: context, 
                            builder: (_) => new AlertDialog(
                                          title: new Text("Error!!!"),
                                          content: new Text("Nhap het cac field dee"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("OK", style: TextStyle(color: appPrimaryColor),),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                      ),
                          );
                        }
                        else if (repeatPasswordController.value.text != passwordController.value.text){
                          showDialog(
                            context: context, 
                            builder: (_) => new AlertDialog(
                                          title: new Text("Error!!!"),
                                          content: new Text("Pass chua trung"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("OK", style: TextStyle(color: appPrimaryColor),),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                      ),
                          );
                        }
                        else {
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
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            )
                          );
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

  void signUp(BuildContext context){
    RegisterWithFirebase(context,emailController.value.text, usernameController.value.text, passwordController.value.text);
  }

  bool isEmpty(){
    if (emailController.value.text != "" && usernameController.value.text != "" && passwordController.value.text != "" && repeatPasswordController.value.text != ""){
        return false;
    }
    return true;
  }

  void RegisterWithFirebase(BuildContext context,String _email, String _username, String _password) async {
    print("[SIGNUP ACC] " + _email + " " + _password + " " + _username);
    try {
      final User user = (await _auth
          .createUserWithEmailAndPassword(
              email: _email, password: _password)).user;
      try {
        user.sendEmailVerification();
      } 
      catch (e) {

      }

      user.updateProfile(displayName: _username);
      // .then((onValue) {
      //   Firestore.instance.collection('users').doc(user.uid).set(
      //     {'email': _email, 'displayName': _username}).then((onValue) {

      //     });
      // });

      showDialog(
          context: context, 
          builder: (_) => new AlertDialog(
                        title: new Text("ERROR!!!"),
                        content: new Text("Sign up success, verify your email before login"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK", style: TextStyle(color: appPrimaryColor),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                    ),
        );
    }
    catch (error) {
      if (error.code == "ERROR_INVALID_EMAIL") {
        showDialog(
          context: context, 
          builder: (_) => new AlertDialog(
                        title: new Text("ERROR!!!"),
                        content: new Text("Invalid email"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK", style: TextStyle(color: appPrimaryColor),),
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
      } else if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        showDialog(
          context: context, 
          builder: (_) => new AlertDialog(
                        title: new Text("ERROR!!!"),
                        content: new Text("Email already in use"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK", style: TextStyle(color: appPrimaryColor),),
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
      } else if (error.code == "ERROR_WEAK_PASSWORD") {
        showDialog(
          context: context, 
          builder: (_) => new AlertDialog(
                        title: new Text("ERROR!!!"),
                        content: new Text("Your password is too weak"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK", style: TextStyle(color: appPrimaryColor),),
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
}