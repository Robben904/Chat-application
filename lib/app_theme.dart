import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();
  static Color kPrimaryColor = Color.fromARGB(255, 152, 185, 237);
  static Color kPrimaryColorVariant = Color.fromARGB(255, 102, 101, 116);
  static Color kAccentColor = Color.fromARGB(255, 255, 255, 255);
  static Color kAccentColorVariant = Color.fromARGB(255, 240, 240, 240);
  static Color kUnreadChatBG = Color(0xffEE1D1D);

  static final TextStyle heading2 = TextStyle(
    color: Color(0xff686795),
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static final TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static final TextStyle snap = TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 16,
      fontFamily: 'snap',
      letterSpacing: 1.2,
      fontWeight: FontWeight.w700);

  static final TextStyle bodyTextMessage =
      TextStyle(fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.bold);

  static final TextStyle bodyTextTime = TextStyle(
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}
