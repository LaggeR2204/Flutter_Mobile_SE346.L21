import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class MessengerPage extends StatefulWidget {
  @override
  MessengerPageState createState() => MessengerPageState();
}

class MessengerPageState extends State<MessengerPage> {
  final double appBarHeight = AppBar().preferredSize.height;
  var newMessageIcon = Icons.edit_rounded;
  Widget newMessage = Text("Message");

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
              colors: <Color>[
                appPrimaryColor,
                appPrimaryColor2
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: newMessage,
        actions: [
          IconButton(
            icon: Icon(newMessageIcon), 
            padding: EdgeInsets.only(right: 10.0), 
            onPressed: (){
              setState(() {
                if (this.newMessageIcon == Icons.edit_rounded) {
                  this.newMessageIcon = Icons.cancel;
                  this.newMessage = Container(
                                      height: appBarHeight * 0.8,
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: appPrimaryLightColor,
                                        borderRadius:  BorderRadius.circular(29),
                                      ),
                                      child: TextField(
                                        cursorColor: appPrimaryColor,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: appBarHeight * 0.3),
                                          hintText: 'Search',
                                          suffixIcon: Icon(Icons.search),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                                        ),
                                      ),
                                    );
                } 
                else {
                  this.newMessageIcon = Icons.edit_rounded;
                  this.newMessage = Text("Message");
                }
              });
            }
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: appPrimaryColor,
              tabs: [
                Tab(icon: Icon(Icons.chat, color: appPrimaryColor,),),
                Tab(icon: Icon(Icons.people, color: appPrimaryColor,))
              ],
            ),
          body: TabBarView(
            children: [
              Center(child: Text("Chat page")),
              Center(child: Text("People page")),
            ],
          ),
        )
      ),
    );
  }
}