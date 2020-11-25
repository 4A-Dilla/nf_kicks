import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/user_state_page.dart';
import 'services/auth/auth.dart';
import 'services/auth/base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Base>(
      create: (context) => Auth(),
      child: Container(
        child: MaterialApp(
          title: 'Nf_Kicks',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: UserStatePage(),
        ),
      ),
    );
  }
}
