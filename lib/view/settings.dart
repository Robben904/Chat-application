import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:loginapp/app_theme.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/view/aboutus.dart';
import 'package:loginapp/view/changepasswordpage.dart';
import 'package:loginapp/view/profileedit.dart';
import 'package:loginapp/view/viewprofile.dart';

import '../utils/remoteservices.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);
  DatasavingController dsc = DatasavingController();

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
              : ListView(
                  children: [
                    AppBar(
                      centerTitle: true,
                      backgroundColor: MyTheme.kPrimaryColor,
                      title: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "snap",
                            color: Colors.white),
                      ),
                      elevation: 0,
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: MyTheme.kPrimaryColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(18),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                RemoteServices.initialUrl +
                                    "/profileimages/" +
                                    snapshot.data!.profileimage),
                            radius: 28,
                          ),
                          onTap: () async {
                            DatasavingController dsc = DatasavingController();
                            ProfileModel? profileModel =
                                await dsc.readProfile();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewProfile(
                                  profile: profileModel!,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            snapshot.data!.username,
                            style: getTextStyle(18),
                          ),
                          subtitle: Text(
                            snapshot.data!.email,
                            style: getTextStyle(12),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Profile Edit",
                        style: MyTheme.snap,
                      ),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEdit(),
                          ),
                        );
                      },
                    ),
                    // ListTile(
                    //   title: Text("Notification", style: MyTheme.snap),
                    //   trailing: Switch(
                    //     value: false,
                    //     onChanged: (val) {},
                    //   ),
                    // ),
                    // ListTile(
                    //   title: Text(
                    //     "Blocked",
                    //     style: MyTheme.snap,
                    //   ),
                    //   trailing: Icon(Icons.block),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => BlockPage()),
                    //     );
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        "Report a Problem",
                        style: MyTheme.snap,
                      ),
                      trailing: Icon(Icons.priority_high),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutUs()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Change password",
                        style: MyTheme.snap,
                      ),
                      trailing: Icon(Icons.password),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Donation",
                        style: MyTheme.snap,
                      ),
                      trailing: Icon(Icons.payments),
                      onTap: () {
                        final config = PaymentConfig(
                          amount: 10000, // Amount should be in paisa
                          productIdentity: 'dell-g5-g5510-2021',
                          productName: 'Dell G5 G5510 2021',
                          productUrl: 'https://www.khalti.com/#/bazaar',
                        );
                        KhaltiScope.of(context).pay(
                          config: config,
                          preferences: [
                            PaymentPreference.khalti,
                            PaymentPreference.connectIPS,
                            PaymentPreference.eBanking,
                            PaymentPreference.sct,
                          ],
                          onSuccess: (success) {},
                          onFailure: (failure) {},
                          onCancel: () {},
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Log out",
                        style: MyTheme.snap,
                      ),
                      trailing: Icon(Icons.logout),
                      onTap: () {
                        //Navigator.push(
                        //  context,
                        //  MaterialPageRoute(builder: (context) => MyLogin()),
                        //);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Are you sure want to log out?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    DatasavingController dsc =
                                        DatasavingController();
                                    dsc.logout();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'login',
                                      (route) => false,
                                    );
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }

  TextStyle getTextStyle(double size) {
    return TextStyle(
      fontSize: size,
      fontFamily: "snap",
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}
