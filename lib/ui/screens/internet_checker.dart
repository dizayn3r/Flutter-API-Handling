import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  const InternetChecker({super.key, required this.child});

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  List<ConnectivityResult> _connectivityResult = [];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    _checkInternetConnection();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectivityResult = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    log("In checkInternetConnection", name: "InternetChecker");
    var connectivityResult = await Connectivity().checkConnectivity();
    log("In checkInternetConnection ${connectivityResult}",
        name: "InternetChecker");
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _connectivityResult.contains(ConnectivityResult.wifi) &&
            _connectivityResult.contains(ConnectivityResult.mobile) !=
                ConnectivityResult.none
        ? widget.child
        : _buildNoInternetScreen();
  }

  Widget _buildNoInternetScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkInternetConnection,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
