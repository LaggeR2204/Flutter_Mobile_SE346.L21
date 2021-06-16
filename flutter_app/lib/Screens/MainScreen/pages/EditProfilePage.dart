import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/RoundedButton.dart';
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
  void initState() {
    if (currentUserModel == null) {
      print("[NULLLLLLLLLLL]");
    } else {
      print("[current photourl ]" + currentUserModel.photoUrl);
    }
    file = null;
    super.initState();
  }

  _selectNewImage(BuildContext parentContext) async {
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          color: Color(0xFF737373),
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              color: appPrimaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(29),
                topRight:  const Radius.circular(29),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Upload Photo',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 10,),
                RoundedButton(
                  text: "Take a photo",
                  press: () async {
                    Navigator.pop(context);
                    PickedFile imageFile = await imagePicker.getImage(
                        source: ImageSource.camera,
                        maxWidth: 1920,
                        maxHeight: 1200,
                        imageQuality: 80);
                    setState(() {
                      file = File(imageFile.path);
                    });
                  },
                ),
                RoundedButton(
                  text: "Choose from Gallery",
                  press: () async {
                    Navigator.of(context).pop();
                    PickedFile imageFile = await imagePicker.getImage(
                        source: ImageSource.gallery,
                        maxWidth: 1920,
                        maxHeight: 1200,
                        imageQuality: 80);
                    setState(() {
                      file = File(imageFile.path);
                    });
                  },
                ),
                RoundedButton(
                  text: "Cancel",
                  press:  () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  changeProfileImage(BuildContext context) async {
    file = null;
    await _selectNewImage(context);
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("profile_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  reloadCurrentModelUserData() async {
    DocumentSnapshot userRecord = await ref.doc(currentUserModel.id).get();
          if (userRecord.data() != null) {}
          userRecord = await ref.doc(currentUserModel.id).get();

          currentUserModel = AppUser.fromDocument(userRecord);
          print("[IN-FUNCTION edited photo url] " + currentUserModel.photoUrl);
  }

  applyChanges() async {
    print("[current photo url] " + currentUserModel.photoUrl);
    if (currentUserModel.photoUrl != null) {
      Reference ref =
          FirebaseStorage.instance.refFromURL(currentUserModel.photoUrl);
      ref.delete();
    }
    print("[Ten] " + nameController.text);
    if(file != null){
      uploadImage(file).then((data) => 
        FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserModel.id)
          .update({
            "photoUrl": data,
            "displayName": nameController.text,
            "bio": bioController.text,
          })
          .whenComplete(() async => {
            reloadCurrentModelUserData()
          })
      );
      file = null;
    } else {
      FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserModel.id)
            .update({
          "displayName": nameController.text,
          "bio": bioController.text,
        });
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
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentSnapshot userRecord = await ref.doc(user.uid).get();
          if (userRecord.data() != null) {}
          userRecord = await ref.doc(user.uid).get();

          currentUserModel = AppUser.fromDocument(userRecord);
          print("[edited photo url] " + currentUserModel.photoUrl);
        }
        return true;
      },
      child: FutureBuilder(
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
                    colors: <Color>[appPrimaryColor, appPrimaryColor2],
                  ),
                ),
              ),
              title: Container(
                child: Text("Edit Profile"),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      applyChanges().then(
                        Navigator.maybePop(context)
                      );
                    })
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
              children: <Widget>[
                SizedBox(height: 40,),
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      (file != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            file,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : ((currentUserModel.photoUrl != null)
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(currentUserModel.photoUrl),
                              radius: 50.0,
                            )
                          : Image.asset(
                              "assets/images/defaultProfileImage.png")),
                      Positioned(
                        bottom: -10,
                        right: -25,
                        child: RawMaterialButton(
                          onPressed: () {
                            changeProfileImage(context);
                          },
                          elevation: 2.0,
                          fillColor: Colors.white70,
                          //fillColor: Color(0x60FFFFFF),
                          child: Icon(Icons.camera_alt_outlined, color: appPrimaryColor, size: 20,),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder(),
                        )),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                // Stack(
                //   children: <Widget>[
                //     Container(
                //         decoration: new BoxDecoration(color: Colors.white10),
                //         alignment: Alignment.center,
                //         height: 200,
                //         child: (file != null)
                //           ? ClipRRect(
                //               borderRadius: BorderRadius.circular(50),
                //               child: Image.file(
                //                 file,
                //                 width: 100,
                //                 height: 100,
                //                 fit: BoxFit.fitHeight,
                //               ),
                //             )
                //           : ((currentUserModel.photoUrl != null)
                //               ? CircleAvatar(
                //                   backgroundImage:
                //                       NetworkImage(currentUserModel.photoUrl),
                //                   radius: 50.0,
                //                 )
                //               : Image.asset(
                //                   "assets/images/defaultProfileImage.png"))
                //     ),
                //     Positioned(
                //       bottom: 45, 
                //       right: size.width * 0.5 - 55,
                //       child: IconButton(
                //         onPressed: (){
                //           changeProfileImage(context);
                //         },
                //         icon: Icon(Icons.add_circle_rounded, color: appPrimaryColor, size: 35,)
                //       ),
                //       // child: Icon(
                //       //   Icons.edit_rounded,
                //       //   color: appPrimaryColor,
                //       // ),
                //     ),
                //   ],
                // ),
                // Padding(
                //     padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                //     child: (file != null)
                //         ? ClipRRect(
                //             borderRadius: BorderRadius.circular(50),
                //             child: Image.file(
                //               file,
                //               width: 100,
                //               height: 100,
                //               fit: BoxFit.fitHeight,
                //             ),
                //           )
                //         : ((currentUserModel.photoUrl != null)
                //             ? CircleAvatar(
                //                 backgroundImage:
                //                     NetworkImage(currentUserModel.photoUrl),
                //                 radius: 50.0,
                //               )
                //             : Image.asset(
                //                 "assets/images/defaultProfileImage.png"))),
                // FlatButton(
                //     onPressed: () {
                //       changeProfileImage(context);
                //     },
                //     child: Text(
                //       "Change Photo",
                //       style: const TextStyle(
                //           color: Colors.black,
                //           fontSize: 20.0,
                //           fontWeight: FontWeight.bold),
                //     )),
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
            )
          );
        }),
    );
  }
}
