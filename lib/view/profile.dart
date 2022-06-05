import 'package:flutter/material.dart';
import 'package:loginapp/constants.dart';

class Settingpage extends StatelessWidget {
  const Settingpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        color: kPrimaryColor,
        child: OutlinedButton(
          onPressed: () {},
          child: Container(
            color: kPrimaryColor,
            child: Text("Friends"),
          ),
        ),
      ),
    );
  }
}
