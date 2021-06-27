import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/SearchChatUser.dart';
import 'package:flutter_app/constants.dart';

class MessengerPage extends StatefulWidget {
  @override
  MessengerPageState createState() => MessengerPageState();
}

class MessengerPageState extends State<MessengerPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[appPrimaryColor, appPrimaryColor2],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text("Message"),
          actions: [
            IconButton(
                icon: Icon(Icons.edit_rounded),
                padding: EdgeInsets.only(right: 10.0),
                onPressed: () {
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SearchUserChat();
                      },
                    ));
                  });
                }),
          ],
        ),
        body: Container());
  }
}
