import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/AppUser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../constants.dart';


class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePage_State createState() => EditProfilePage_State();
}

class EditProfilePage_State extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File file;
  ImagePicker imagePicker = ImagePicker();

  @override
  void initState(){
    if (currentUserModel == null) {
      print("[NULLLLLLLLLLL]");
    }
    else{
      print("[current photourl ]"+currentUserModel.photoUrl);

    }
    file = null;
    super.initState();
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

  applyChanges() async {
    print("[current photo url] " + currentUserModel.photoUrl);
    if(currentUserModel.photoUrl != null){
      Reference ref = FirebaseStorage.instance.refFromURL(currentUserModel.photoUrl);
      ref.delete();
    }
    uploadImage(file).then((data) => 
      FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserModel.id)
        .update({
          "photoUrl" : data,
          "displayName": nameController.text,
          "bio": bioController.text,
        })
    );

    file = null;
    if(file == null){
      print("[FILE DA NULL]");
    }

    var user = FirebaseAuth.instance.currentUser;
    if(user != null){
      DocumentSnapshot userRecord = await ref.doc(user.uid).get();
      if (userRecord.data() != null) {
      }
        userRecord = await ref.doc(user.uid).get();

      currentUserModel = AppUser.fromDocument(userRecord);
      print("[edited photo url] " + currentUserModel.photoUrl);
    }
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
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserModel.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          AppUser user = AppUser.fromDocument(snapshot.data);

          print(user.displayName + " " + user.bio);

          nameController.text = user.displayName;
          bioController.text = user.bio;
          
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
                    ((currentUserModel.photoUrl != null)?
                    CircleAvatar(
                      backgroundImage: NetworkImage(currentUserModel.photoUrl),
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
                      buildTextField(name: "Bio", controller: bioController),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}