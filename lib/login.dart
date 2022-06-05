import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/logincontroller.dart';

class MyLogin extends StatefulWidget {
  MyLogin({Key? key}) : super(key: key);
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/UI2.png'), fit: BoxFit.cover)),
      child: Form(
        key: loginForm,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 35, top: 145),
                child: Text(
                  'Welcome\nBack',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.45,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Please enter email address";
                          }
                          if (!value.toString().isEmail) {
                            return "Please enter valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 58,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 27,
                                fontWeight: FontWeight.w700),
                          ),
                          GetBuilder<LoginController>(
                            init: LoginController(),
                            initState: (_) {},
                            builder: (_) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFFD50000),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    var bytes = utf8.encode(
                                      passwordController.text,
                                    ); // data being hashed

                                    var digest = sha1.convert(bytes);
                                    if (loginForm.currentState!.validate()) {
                                      _.login(
                                        emailController.text,
                                        digest.toString(),
                                        context,
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.arrow_forward),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    color: Color(0xFFFFEBEE),
                                  ),
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'forgetpassword');
                              },
                              child: Text(
                                'Forget password',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Color(0xFFFFEBEE),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
