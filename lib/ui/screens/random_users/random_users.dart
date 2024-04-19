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
  int pageNumber = 1;
  int limit = 20;

  @override
  initState() {
    getUsers();
    super.initState();
  }

  getUsers() async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    dynamic response = await BaseClient.get(
      baseUrl: "https://api.freeapi.app/api/v1",
      endpoint: "/public/randomusers?page=$pageNumber&limit=$limit",
      headers: headers,
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
      body: Column(
        children: [
          // UserList
          hasData
              ? Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: randomUserResponse.data!.data!.length,
                    itemBuilder: (context, index) {
                      User? user = randomUserResponse.data!.data?[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(user?.picture?.large ?? ""),
                            ),
                            title: Text(
                              "${user?.name?.first} ${user?.name?.last}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("${user?.email}"),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          // Pagination
          Visibility(
            visible: userData.isNotEmpty,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: hasPreviousPage
                        ? () {
                            hasData = !hasData;
                            setState(() {
                              pageNumber -= 1;
                            });
                            getUsers();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: const Icon(FontAwesomeIcons.arrowLeft),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        userData.isNotEmpty
                            ? "Page ${userData["data"]["page"]} of ${userData["data"]["totalPages"]}"
                            : "--",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: hasNextPage
                        ? () {
                            hasData = !hasData;
                            setState(() {
                              pageNumber += 1;
                            });
                            getUsers();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: const Icon(FontAwesomeIcons.arrowRight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
