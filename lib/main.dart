import 'package:api_handling/providers/user_provider.dart';
import 'package:api_handling/ui/screens/internet_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter API Handling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
          ),
        ),
        home: const InternetChecker(child: Home()),
      ),
    );
  }
}
