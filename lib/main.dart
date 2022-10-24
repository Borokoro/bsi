import 'package:bsi/Login/LoggedIn.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'Login/Login.dart';
import 'firebase_options.dart';
import 'Router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Routers().router,
      title: 'BSI',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      ));
}

class Addd extends StatefulWidget {
  const Addd({Key? key}) : super(key: key);

  @override
  State<Addd> createState() => _AdddState();
}

class _AdddState extends State<Addd> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
