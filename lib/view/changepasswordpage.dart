import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginapp/controller/changepasswordcontroller.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController email = TextEditingController();

  TextEditingController currentPassword = TextEditingController();

  TextEditingController newPassword = TextEditingController();

  TextEditingController newPasswordConfirm = TextEditingController();

  GlobalKey<FormState> changePassform = GlobalKey<FormState>();

  bool currentPasswordHidden = true;

  bool newPasswordHidden = true;

  bool newPasswordConfirmHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Iconimage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GetBuilder<ChangePasswordController>(
          init: ChangePasswordController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: changePassform,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                    ),
                    TextFormField(
                      controller: email,
                      decoration: getInputDecoration(
                        "Enter your email address",
                        () {},
                        false,
                        false,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Email cannot be empty";
                        }
                        if (!value.toString().isEmail) {
                          return "Please enter valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        obscureText: currentPasswordHidden,
                        decoration: getInputDecoration(
                          "Enter your Current password",
                          () {
                            setState(() {
                              currentPasswordHidden = !currentPasswordHidden;
                            });
                          },
                          currentPasswordHidden,
                          true,
                        ),
                        controller: currentPassword,
                        validator: (value) {
                          if (value == "") {
                            return "Password Cannot be empty";
                          }
                          if (value.toString().length < 8) {
                            return "Password should be at least 8 character long";
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: newPasswordHidden,
                      controller: newPassword,
                      decoration: getInputDecoration(
                        "Enter your new password",
                        () {
                          setState(() {
                            newPasswordHidden = !newPasswordHidden;
                          });
                        },
                        newPasswordHidden,
                        true,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Password Cannot be empty";
                        }
                        if (value.toString().length < 8) {
                          return "Password should be at least 8 character long";
                        }
                        if (newPassword.text == currentPassword.text) {
                          return "Current password and New password are same";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: newPasswordConfirmHidden,
                      decoration: getInputDecoration(
                        "Confirm your new password",
                        () {
                          setState(() {
                            newPasswordConfirmHidden =
                                !newPasswordConfirmHidden;
                          });
                        },
                        newPasswordConfirmHidden,
                        true,
                      ),
                      controller: newPasswordConfirm,
                      validator: (value) {
                        if (newPassword.text != newPasswordConfirm.text) {
                          return "Password do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (changePassform.currentState!.validate()) {
                          var bytes = utf8.encode(
                              currentPassword.text); // data being hashed

                          var digest = sha1.convert(bytes);

                          var bytes2 = utf8
                              .encode(newPassword.text); // data being hashed

                          var digest2 = sha1.convert(bytes2);
                          controller.changePassword(
                            context,
                            email.text,
                            digest.toString(),
                            digest2.toString(),
                          );
                        } else {}
                      },
                      child: const Text("Change Password"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

InputDecoration getInputDecoration(
  String hint,
  Function onPress,
  bool hidden,
  bool isPassword,
) {
  return InputDecoration(
    hintText: hint,
    border: InputBorder.none,
    fillColor: Colors.grey,
    filled: true,
    suffixIcon: isPassword
        ? IconButton(
            onPressed: () {
              onPress();
            },
            icon: Icon(
              hidden ? Icons.visibility_off : Icons.visibility,
            ),
          )
        : const SizedBox.shrink(),
  );
}
