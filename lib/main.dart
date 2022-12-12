import 'package:bsi/Login/LoggedIn.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/services.dart';
import 'Login/Login.dart';
import 'firebase_options.dart';
import 'Router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final ipv4 = await Ipify.ipv4();
  print("hhhhhhhhhhhhhh $ipv4");
  final int time=DateTime.now().hour;
  print(DateTime.now());
  runApp( MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Routers().router,
      title: 'BSI',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      ));
}

