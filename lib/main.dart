import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:loginapp/login.dart';
import 'package:loginapp/register.dart';
//import 'package:loginapp/chats_Screen.dart';
import 'package:loginapp/CustomUI/chat_card.dart';
import 'package:loginapp/view/blockpage.dart';
import 'package:loginapp/view/changepasswordpage.dart';
import 'package:loginapp/view/homepage.dart';
import 'package:loginapp/view/mappage.dart';
import 'package:loginapp/view/profileedit.dart';
import 'package:loginapp/view/resetpasswordpage.dart';
import 'package:loginapp/view/searchfriend.dart';
import 'package:loginapp/view/settings.dart';
import 'package:loginapp/view/splashpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    KhaltiScope(
      publicKey: "test_public_key_8496a824f03440c4b9480a9279aeb6dc",
      builder: (context, navigatorKey) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          theme: ThemeData(
              fontFamily: "OpenSans", primaryColor: Color(0xFF075E54)),
          debugShowCheckedModeBanner: false,
          initialRoute: 'splash',
          routes: {
            'splash': (_) => SplashPage(),
            'login': (context) => MyLogin(),
            'register': (context) => MyRegister(),
            //'ChatsScreen': (context) => ChatsScreen(),
            'ChatCard': (context) => CustomCard(),
            'homepage': (context) => Homepage(),
            'searchfriend': (context) => Searchfriends(),
            'settings': (context) => Settings(),
            'profileedit': (context) => ProfileEdit(),
            'blockpage': (context) => BlockPage(),
            'mappage': (context) => MapPage(),
            'changepasswordpage': (context) => ChangePassword(),
            'forgetpassword': (context) => ForgotPassword(),
          },
        );
      },
    ),
  );
}
