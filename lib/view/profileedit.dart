import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginapp/app_theme.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/controller/updateprofilecontroller.dart';
import 'package:loginapp/models/profilemodel.dart';

import '../utils/remoteservices.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  DatasavingController dsc = DatasavingController();

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController notificationid = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController profileimage = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController chats = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();

  File? file;

  setData(ProfileModel profileModel) {
    username.text = profileModel.username;
    bio.text = profileModel.bio;
    phone.text = profileModel.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProfileModel?>(
        future: dsc.readProfile(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.active ||
                  snapshot.data == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : () {
                  setData(snapshot.data!);
                  return ListView(
                    children: [
                      AppBar(
                        leading: BackButton(color: Colors.black),
                        backgroundColor: Color.fromARGB(210, 255, 255, 255),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "snap"),
                        ),
                        elevation: 0,
                      ),
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.all(6)),
                          GestureDetector(
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image == null) {
                                Fluttertoast.showToast(
                                    msg: "No Files selected");
                              } else {
                                file = File(image.path);
                                setState(() {});
                              }
                            },
                            child: file == null
                                ? CircleAvatar(
                                    radius: 54,
                                    backgroundImage: NetworkImage(
                                        RemoteServices.initialUrl +
                                            "/profileimages/" +
                                            snapshot.data!.profileimage))
                                : CircleAvatar(
                                    radius: 54,
                                    backgroundImage: FileImage(file!),
                                  ),
                          ),
                          Material(
                            child: ListTile(
                              title: Text(
                                'Profile Photo',
                                textAlign: TextAlign.center,
                                style: MyTheme.snap,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          //  ListTile(
                          //    title: Text(
                          //      "Name",
                          //      style: MyTheme.snap,
                          //    ),
                          //    trailing: Text(snapshot.data!.username),
                          //  ),
                        ],
                      ),
                      TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Name',
                            labelText: 'Username'),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      TextFormField(
                        controller: bio,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'bio',
                            labelText: 'Bio'),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //       icon: Icon(Icons.person),
                      //       hintText: 'DOB',
                      //       labelText: 'Birthday'),
                      // ),
                      Padding(padding: EdgeInsets.all(10)),
                      TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Number',
                            labelText: 'Phone Number'),
                      ),
                      Padding(padding: EdgeInsets.all(15)),
                      GetBuilder<UpdateProfileCotroller>(
                          init: UpdateProfileCotroller(),
                          builder: (controller) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(40, 40), // HERE
                              ),
                              onPressed: () {
                                controller.updateprofile(
                                  ProfileModel(
                                      id: snapshot.data!.id,
                                      date: snapshot.data!.date,
                                      username: username.text,
                                      email: snapshot.data!.email,
                                      phone: phone.text,
                                      bio: bio.text,
                                      notificationid:
                                          snapshot.data!.notificationid,
                                      dateofbirth: snapshot.data!.dateofbirth,
                                      profileimage: snapshot.data!.profileimage,
                                      gender: snapshot.data!.gender,
                                      chats: snapshot.data!.chats,
                                      password: snapshot.data!.password,
                                      address: snapshot.data!.address),
                                  context,
                                  file,
                                );
                              },
                              child: Text('Save'),
                            );
                          })
                    ],
                  );
                }();
        },
      ),
    );
  }
}
