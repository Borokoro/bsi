import 'package:bsi/Router.dart';
import 'package:bsi/Login/LoggedIn.dart';
import 'package:bsi/Login/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:bsi/Register/Register.dart';
import 'package:bsi/Login/ChangePass.dart';

class Routers{
  final GoRouter router=GoRouter(routes: <GoRoute>[
    GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
    ),
    GoRoute(
        path:'/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
        path:'/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path:'/login/logs',
      builder: (context, state) => const Login(),
    ),
  ],
  );
}