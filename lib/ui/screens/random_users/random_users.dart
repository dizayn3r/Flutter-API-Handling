import 'dart:convert';
import 'dart:developer';

import 'package:api_handling/model/random_user.dart';
import 'package:api_handling/services/base_client.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RandomUsers extends StatefulWidget {
  const RandomUsers({super.key});

  @override
  State<RandomUsers> createState() => _RandomUsersState();
}

class _RandomUsersState extends State<RandomUsers> {
  Map<String, dynamic> userData = {};
  bool hasPreviousPage = false;
  bool hasNextPage = false;
  bool hasData = false;
  RandomUserResponse randomUserResponse = RandomUserResponse();

  @override
  initState() {
    getUsers();
    super.initState();
  }

  getUsers() async {
    dynamic response = await BaseClient.get(
      "https://api.freeapi.app/api/v1",
      "/public/randomusers?page=1&limit=5",
    );
    dynamic userList = jsonDecode(response);
    RandomUserResponse users = RandomUserResponse.fromJson(userList);
    setState(() {
      hasData = !hasData;
      randomUserResponse = users;
      userData = userList;
      hasPreviousPage = userList["data"]["previousPage"];
      hasNextPage = userList["data"]["nextPage"];
    });
    log("Response: ${users.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Users"),
      ),
      body: hasData
          ? Column(
              children: [
                // Pagination
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: hasPreviousPage ? () {} : null,
                      child: const Icon(FontAwesomeIcons.arrowLeft),
                    ),
                    Expanded(
                      child: Text("${userData["data"]["page"]}"),
                    ),
                    ElevatedButton(
                      onPressed: hasNextPage ? () {} : null,
                      child: const Icon(FontAwesomeIcons.arrowRight),
                    ),
                  ],
                ),
                // UserList
                Expanded(
                  child: ListView.builder(
                    itemCount: randomUserResponse.data?.data?.length,
                    itemBuilder: (context, index) {
                      User? user = randomUserResponse.data!.data?[index];
                      return ListTile(
                        title: Text(user?.name?.first ?? ""),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
