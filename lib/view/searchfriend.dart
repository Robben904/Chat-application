import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginapp/controller/searchfriendcontroller.dart';

import '../utils/remoteservices.dart';

class Searchfriends extends StatelessWidget {
  const Searchfriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchfriendController>(
      init: SearchfriendController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white12,
            title: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search Friends",
              ),
              onChanged: (value) {
                controller.searchFriends(value);
              },
              onFieldSubmitted: (value) {
                controller.searchFriends(value);
              },
            ),
            actions: [],
          ),
          body: controller.allFriends.isEmpty
              ? Center(
                  child: Text("No Users"),
                )
              : ListView.builder(
                  itemCount: controller.allFriends.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            RemoteServices.initialUrl +
                                "/profileimages/" +
                                controller.allFriends[index].profileimage),
                      ),
                      title: Text(controller.allFriends[index].username),
                      subtitle: Text(controller.allFriends[index].email),
                      trailing: IconButton(
                        onPressed: () {
                          controller.sendFriendRequest(
                            controller.allFriends[index].id.toString(),
                          );
                        },
                        icon: Icon(Icons.add),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
