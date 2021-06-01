import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

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

  applyChanges() {
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
    nameController.text = FirebaseAuth.instance.currentUser.displayName;

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
                child: (FirebaseAuth.instance.currentUser.photoURL != null)?
                CircleAvatar(
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                  radius: 50.0,
                )
                :
                Image.asset("assets/images/defaultProfileImage.png")
              ),
              FlatButton(
                onPressed: () {
                  changeProfilePhoto(context);
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
    // return FutureBuilder(
    //     future: FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(FirebaseAuth.instance.currentUser.uid)
    //         .get(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData)
    //         return Container(
    //             alignment: FractionalOffset.center,
    //             child: CircularProgressIndicator());

    //       //User user = User.fromDocument(snapshot.data);

    //       nameController.text = FirebaseAuth.instance.currentUser.displayName;

    //       return Column(
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    //             child: CircleAvatar(
    //               backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
    //               radius: 50.0,
    //             )
    //           ),
    //           FlatButton(
    //             onPressed: () {
    //               changeProfilePhoto(context);
    //             },
    //             child: Text(
    //               "Change Photo",
    //               style: const TextStyle(
    //                   color: Colors.blue,
    //                   fontSize: 20.0,
    //                   fontWeight: FontWeight.bold),
    //             )
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Column(
    //               children: <Widget>[
    //                 buildTextField(name: "Name", controller: nameController),
    //               ],
    //             ),
    //           ),
    //         ],
    //       );
    //     });
  }
}