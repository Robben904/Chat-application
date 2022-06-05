import 'package:flutter/material.dart';
import 'package:loginapp/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kPrimaryColor,
          child: Row(
            children: [],
          ),
        ),
        OutlinedButton(
          child: Text('Friend'),
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.teal,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'viewfriendrequest');
          },
          //Navigator.pushNamed(context, 'searchfriend');
        ),
      ],
    );
  }
}
