import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/resetpasswordcontroller.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> emailForm = GlobalKey<FormState>();

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
        child: GetBuilder<ResetPasswordController>(
          init: ResetPasswordController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: emailForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    controller.requestChangeLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (emailForm.currentState!.validate()) {
                                controller.requestChangePassword(
                                  context,
                                  email.text,
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

class TokenPage extends StatelessWidget {
  TokenPage({Key? key, required this.email}) : super(key: key);
  TextEditingController token = TextEditingController();
  GlobalKey<FormState> tokenForm = GlobalKey<FormState>();

  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Token"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Iconimage.png'), fit: BoxFit.cover),
        ),
        child: GetBuilder<ResetPasswordController>(
            init: ResetPasswordController(),
            builder: (controller) {
              return Form(
                key: tokenForm,
                child: Column(
                  children: [
                    Text(
                        "We have sent an email to $email with Verification code."),
                    Text("Enter the verification code to change password"),
                    TextFormField(
                      controller: token,
                      decoration: getInputDecoration(
                        "Enter the token",
                        () {},
                        false,
                        false,
                      ),
                      validator: (value) {
                        if (value.toString() == "") {
                          return "Please enter the code received";
                        }
                        if (value.toString().length != 6) {
                          return "The code is invalid";
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (tokenForm.currentState!.validate()) {
                          controller.verifyToken(
                            email,
                            token.text,
                            context,
                          );
                        } else {}
                      },
                      child: Text(
                        controller.tokenVerifyLoading
                            ? "Loading..."
                            : "Verify Token",
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key, required this.email, required this.token})
      : super(key: key);
  final String email;
  final String token;
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController newPasswordConfirm = TextEditingController();
  GlobalKey<FormState> passwordForm = GlobalKey<FormState>();
  bool newPasswordHidden = true;
  bool newPasswordConfirmHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set new Password"),
      ),
      body: GetBuilder<ResetPasswordController>(
          init: ResetPasswordController(),
          builder: (controller) {
            return Form(
              key: passwordForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: newPassword,
                    decoration: getInputDecoration(
                      "Enter New Password",
                      () {
                        setState(() {
                          newPasswordHidden = !newPasswordHidden;
                        });
                      },
                      newPasswordHidden,
                      true,
                    ),
                    validator: (value) {
                      if (value.toString() == "") {
                        return "Please a new password";
                      }
                      if (value.toString().length < 8) {
                        return "Password cannot be less than 8 characters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: newPasswordConfirm,
                    decoration: getInputDecoration(
                      "Enter New Password",
                      () {
                        setState(() {
                          newPasswordConfirmHidden = !newPasswordConfirmHidden;
                        });
                      },
                      newPasswordConfirmHidden,
                      true,
                    ),
                    validator: (value) {
                      if (value.toString() == "") {
                        return "Please a new password";
                      }
                      if (value.toString().length < 8) {
                        return "Password cannot be less than 8 characters";
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (passwordForm.currentState!.validate()) {
                        var bytes =
                            utf8.encode(newPassword.text); // data being hashed
                        var digest = sha1.convert(bytes);

                        controller.changePassword(
                          widget.email,
                          digest.toString(),
                          // newPassword.text,
                          widget.token,
                          context,
                        );
                      } else {}
                    },
                    child: Text(controller.changePasswordLoading
                        ? "Loading..."
                        : "Change Password"),
                  ),
                ],
              ),
            );
          }),
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
