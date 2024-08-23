import 'package:api_handling/ui/screens/random_users/random_users.dart';
import 'package:api_handling/ui/screens/random_users/random_users_infinite_scrolling.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Handling"),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RandomUsers(),
                ),
              );
            },
            title: const Text("Random Users"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RandomUsersInfiniteScrolling(),
                ),
              );
            },
            title: const Text("Random Users Infinite Scrolling"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
