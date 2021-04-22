import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/HomePage.dart';
import 'package:flutter_app/Screens/Signup/SignUp.dart';
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
                  Text("Welcome back!", style: TextStyle(fontSize: size.height * 0.05, color: Colors.black),),
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
                    child: RoundedPasswordField(
                      hintText: "Password",
                      controller: passwordController,
                      onChanged: (value){},
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Text(
                      "Foggot Password?",
                      style: TextStyle(color: appPrimaryColor),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01,),
                  RoundedButton(
                      text: "LOGIN",
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
                        else{
                          login(context);
                        }
                      },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            )
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: appPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05,),
                ],
              ),
            ),
        ],
      ),
    );
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login(BuildContext context){
    LoginWithFirebase(context,emailController.value.text, passwordController.value.text);
    
  }

  bool isEmpty(){
    if (emailController.value != null && passwordController.value != null)
      return false;
    return true;
  }

  void LoginWithFirebase(BuildContext context, String _email, String _password) async {
    //Dang nhap voi firebase
    print("[ACC] " + _email + " " + _password);
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      )).user;
      if (user != null){
        if(user.isEmailVerified){ 
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            )
          );
        }
        else{
          print("[ERROR] Verify email"); 
        }
      }
      else{
        print("[ERROR] Null user"); 
      }
    } catch (e) {
      print("[ERROR] " + e.code);
      if (e.code == "ERROR_WRONG_PASSWORD") {
        passwordController.clear();
      } else if (e.code == "ERROR_USER_NOT_FOUND"){
        passwordController.clear();
        emailController.clear();
      }
    }
    
  }
}