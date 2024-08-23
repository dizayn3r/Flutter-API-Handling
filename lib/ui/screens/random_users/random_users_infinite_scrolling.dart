import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enum/notifier_state.dart';
import '../../../providers/user_provider.dart';

class RandomUsersInfiniteScrolling extends StatefulWidget {
  const RandomUsersInfiniteScrolling({super.key});

  @override
  State<RandomUsersInfiniteScrolling> createState() => _RandomUsersInfiniteScrollingState();
}

class _RandomUsersInfiniteScrollingState extends State<RandomUsersInfiniteScrolling> {
  int pageNumber = 1;
  int limit = 20;
  final _listScroll = ScrollController();

  @override
  initState() {
    Provider.of<UserProvider>(context, listen: false).users.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
      _listScroll.addListener(() {
        if (_listScroll.position.pixels == _listScroll.position.maxScrollExtent) {
          getUsers();
        }
      });
    });
    super.initState();
  }

  getUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers(pageNumber, limit);
    setState(() {
      pageNumber++;
    });
  }

  @override
  void dispose() {
    _listScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Users - Infinite Scrolling"),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.state == NotifierState.initial) {
            return Text("NotifierState: ${provider.state}");
          }
          else if (provider.state == NotifierState.loading && provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            if (provider.failure != null) {
              return Text(provider.failure.toString());
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _listScroll,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: provider.users.length,
                      itemBuilder: (context, index) {
                        final user = provider.users[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.picture!.large ?? ""),
                              ),
                              title: Text(
                                "${user.name?.first} ${user.name?.last}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("${user.email}"),
                              trailing: CircleAvatar(
                                child: Text("$index"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: provider.state == NotifierState.loading && provider.users.isNotEmpty,
                    child: const CircularProgressIndicator(),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
