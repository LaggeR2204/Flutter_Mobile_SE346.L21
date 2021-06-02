import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart';


class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePage_State createState() => EditProfilePage_State();
}
class EditProfilePage_State extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  File file;
  ImagePicker imagePicker = ImagePicker();

  @override
  void initState(){
    nameController.text = FirebaseAuth.instance.currentUser.displayName;
    super.initState();
  }

  changeProfilePhoto(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Changing your profile photo has not been implemented yet'),
              ],
            ),
          ),
        );
      },
    );
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                   PickedFile imageFile =
                      await imagePicker.getImage(source: ImageSource.camera, maxWidth: 1920, maxHeight: 1200, imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile =
                      await imagePicker.getImage(source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1200, imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  changeProfileImage(BuildContext context) async {
    file = null;
    await _selectImage(context);
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("profile_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  applyChanges() {
    String oldAvatarURL = FirebaseAuth.instance.currentUser.photoURL;
    if(oldAvatarURL != null){
      Reference ref = FirebaseStorage.instance.refFromURL(FirebaseAuth.instance.currentUser.photoURL);
      ref.delete();
    }
    uploadImage(file).then((data) => 
      FirebaseAuth.instance.currentUser.updateProfile(photoURL: data)
    ).then((value) => 
        file = null
    );
    FirebaseAuth.instance.currentUser.updateProfile(displayName: nameController.text);
  }

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: true,
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
        title: Container(
          child: Text("Edit Profile"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check), 
            onPressed: (){
              applyChanges();
              Navigator.maybePop(context);
            }
          )
        ],
      ),
      body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: (file != null) ?
                ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        file,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                :
                ((FirebaseAuth.instance.currentUser.photoURL != null)?
                CircleAvatar(
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                  radius: 50.0,
                )
                :
                Image.asset("assets/images/defaultProfileImage.png"))
              ),
              FlatButton(
                onPressed: () {
                  changeProfileImage(context);
                },
                child: Text(
                  "Change Photo",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    buildTextField(name: "Name", controller: nameController),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}