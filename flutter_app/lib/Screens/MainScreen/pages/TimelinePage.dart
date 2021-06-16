import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/UploadPage.dart';
import 'package:flutter_app/constants.dart';
import 'package:image_picker/image_picker.dart';

class TimelinePage extends StatefulWidget {
  @override
  TimelinePageState createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage> {
  final double appBarHeight = AppBar().preferredSize.height;
  File _image;
  final imagePicker = ImagePicker();

  Future _getImageFromCamera() async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage(file: _image)));
  }

  Future _getImageFromGallery() async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage(file: _image)));
  }

  Future<void> _showChoiceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Chosing Image From",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Time New Roman',
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                  child: Text(
                "Camera",
                style: TextStyle(
                  fontFamily: 'Time New Roman',
                  fontSize: 18,
                ),
              ),
                onPressed: _getImageFromCamera,
              ),
              CupertinoDialogAction(
                  child: Text(
                "Gallery",
                style: TextStyle(
                  fontFamily: 'Time New Roman',
                  fontSize: 18,
                ),
              ),
                  onPressed: _getImageFromGallery,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.dark,
        title: Text(
          appName,
          style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: appBarHeight * 0.7,
              fontStyle: FontStyle.italic),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[appPrimaryColor, appPrimaryColor2],
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add_circle_rounded),
              onPressed: (){_showChoiceDialog(context);},
          )
        ],
      ),
      body: Center(
        child: Text("Timeline Page"),
      ),
    );
  }
}
