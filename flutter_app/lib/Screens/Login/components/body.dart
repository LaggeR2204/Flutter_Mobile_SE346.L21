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
                  Text("Welcome back!", style: TextStyle(fontSize: 40, color: Colors.black),),
                  SizedBox(height: size.height * 0.05,),
                  TextFieldContainer(
                    child: RoundedTextField(
                      icon: Icons.email,
                      hintText: "Email",
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedPasswordField(
                      hintText: "Password",
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
                ],
              ),
            ),
        ],
      ),
    );
  }

  void login(BuildContext context){
    print("Dang Ky");
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      )
    );
  }

  bool isEmpty(){
    return false;
  }
}