import 'package:api_handling/enum/notifier_state.dart';
import 'package:api_handling/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomUsers extends StatefulWidget {
  const RandomUsers({super.key});

  @override
  State<RandomUsers> createState() => _RandomUsersState();
}

class _RandomUsersState extends State<RandomUsers> {
  int pageNumber = 1;
  int limit = 20;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });
    super.initState();
  }

  getUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers(pageNumber, limit);
  }

  void nextPage() {
    setState(() {
      pageNumber++;
    });
    getUsers();
  }

  void previousPage() {
    setState(() {
      if (pageNumber > 1) {
        pageNumber--;
      }
    });
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Users"),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.state == NotifierState.initial) {
            return Text("NotifierState: ${provider.state}");
          } else if (provider.state == NotifierState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (provider.failure != null) {
              return Text(provider.failure.toString());
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: provider.userResponse.data?.data?.length,
                      itemBuilder: (context, index) {
                        final user = provider.userResponse.data?.data?[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user!.picture!.large ?? ""),
                              ),
                              title: Text(
                                "${user.name?.first} ${user.name?.last}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("${user.email}"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: provider.userResponse.data!.previousPage
                              ? previousPage
                              : null,
                          child: const Text('Previous'),
                        ),
                        Text(
                          "Page ${provider.userResponse.data!.page} of ${provider.userResponse.data!.totalPages}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: provider.userResponse.data!.nextPage
                              ? nextPage
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }
        },
      ),
    );
  }
}
