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
                  Text("Let's Get Started!", style: TextStyle(fontSize: 40, color: Colors.black),),
                  SizedBox(height: size.height * 0.05,),
                  TextFieldContainer(
                    child: RoundedTextField(
                      icon: Icons.email,
                      hintText: "Email",
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedTextField(
                      icon: Icons.person,
                      hintText: "Username",
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedPasswordField(
                      hintText: "Password",
                      onChanged: (value){},
                    ),
                  ),
                  TextFieldContainer(
                    child: RoundedPasswordField(
                      hintText: "Repeat Password",
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
                        else{
                          signUp();
                        }
                      },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already an account? "),
                      GestureDetector(
                        onTap: () {
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

  void signUp(){
    print("Dang Ky");
  }

  bool isEmpty(){
    return true;
  }
}