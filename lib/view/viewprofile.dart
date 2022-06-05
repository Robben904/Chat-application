import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginapp/app_theme.dart';
import 'package:loginapp/models/profilemodel.dart';

import '../utils/remoteservices.dart';

class ViewProfile extends StatelessWidget {
  ViewProfile({Key? key, required this.profile}) : super(key: key);

  final ProfileModel profile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
              CircleAvatar(
                radius: 54,
                backgroundImage: NetworkImage(RemoteServices.initialUrl +
                    "/profileimages/" +
                    profile.profileimage),
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

              // Text("a,jsdjash"),
            ],
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              ListTile(
                title: Text(
                  "Name",
                  style: MyTheme.snap,
                ),
                trailing: Text(profile.username),
              ),
            ],
          ),
          ListTile(
            title: Text(
              "Bio",
              style: MyTheme.snap,
            ),
            trailing: Text(profile.bio),
          ),
          ListTile(
            title: Text("Birthday", style: MyTheme.snap),
            trailing: Text(
                DateFormat("MMMM dd yyyy EEE").format(profile.dateofbirth)),
          ),
          ListTile(
            title: Text("Mobile Number", style: MyTheme.snap),
            trailing: Text(profile.phone),
          ),
          ListTile(
            title: Text("Email", style: MyTheme.snap),
            trailing: Text(profile.email),
          ),
          ListTile(
            title: Text("Password", style: MyTheme.snap),
            trailing: Text("Change password"),
          ),
        ],
      ),
    );
  }
}
