import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/pages/loading_page.dart';
import 'package:nf_kicks/pages/something_went_wrong_page.dart';
import 'package:provider/provider.dart';

import 'pages/user_state_page.dart';
import 'services/auth/auth.dart';
import 'services/auth/base.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  bool _connectionStatusBool = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        _connectionStatusBool = true;
      });
    } else {
      setState(() {
        _connectionStatusBool = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nf_Kicks',
      home: _connectionStatusBool
          ? FutureBuilder(
              future: _init,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SomethingWentWrong();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Provider<Base>(
                    create: (context) => Auth(),
                    child: UserStatePage(),
                  );
                }
                return Loading(
                  loadingWidget: kLoadingLogo,
                );
              },
            )
          : SomethingWentWrong(),
    );
  }
}
