import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:time/time.dart';
import 'LoggedIn.dart';
import 'package:bsi/Firebase/Firebase.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:bsi/Register/Register.dart';
import 'package:bsi/Pepper.dart' as variable;
import 'package:go_router/go_router.dart';
import 'package:bsi/Router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bsi/Functions/Functions.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String login = "";
  String pass = "";
  List<String> attempts=<String>[];
  Functions f=Functions();
  AddUserToDatabase add=AddUserToDatabase();
  IpAdresses ip = IpAdresses();
  String ipv4="nie";
  late DateTime date;
  late DateTime dateFromBase;
  late int usAttempts;
  bool isUserBlocker=false;

  Future<void> getData() async{
    dateFromBase=await ip.getLastAttempt(ipv4);
    usAttempts=await ip.getUsAteempts(ipv4);
  }


  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Log in',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Username: ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 30),
                              validator: (val) =>
                                  val == '' ? 'Enter login' : null,
                              onChanged: (val) {
                                setState(() {
                                  login = val.trim();
                                });
                              },
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Password: ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              obscureText: true,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 30),
                              validator: (val) =>
                                  val == '' ? 'Enter password' : null,
                              onChanged: (val) {
                                setState(() {
                                  pass = val.trim();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 8,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              color: Colors.transparent,
                              border: Border.all(
                                width: 5,
                                color: Colors.white,
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                            ),
                          ),
                          onTap: () async {
                            ipv4 = await Ipify.ipv4();
                            await getData();
                            bool userExist = await GetUserFromDatabase()
                                .doesUserExist(login);
                            if (userExist == true) {
                              attempts = await ip.getIpAdress(login);
                              String salt =
                                  await GetUserFromDatabase().getSalt(login);
                              String password =
                                  await GetUserFromDatabase().getPass(login);
                              if (await GetUserFromDatabase().getWhich(login) ==
                                  "sha512") {
                                if (f.hashSha512(salt, pass) == password) {
                                  usAttempts=0;
                                  await ip.updateAttempts(usAttempts, ipv4);
                                  date = DateTime.now();
                                  attempts.add("${ipv4}/${date}/true");
                                  attempts = attempts.reversed.toList();
                                  await add.addLoginAttempt(login, attempts);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoggedIn(user: login)));
                                } else {
                                  usAttempts++;
                                  await ip.updateAttempts(usAttempts, ipv4);
                                  date = DateTime.now();
                                  attempts.add("${ipv4}/${date}/false");
                                  attempts = attempts.reversed.toList();
                                  await add.addLoginAttempt(login, attempts);
                                  Fluttertoast.showToast(
                                    toastLength: Toast.LENGTH_SHORT,
                                    msg: 'Something went wrong',
                                    webBgColor: '#FF0000',
                                    textColor: Colors.white,
                                    webPosition: 'center',
                                  );
                                }
                              } else {
                                if (f.hashHMAC(salt, pass) == password) {
                                  usAttempts=0;
                                  await ip.updateAttempts(usAttempts, ipv4);
                                  date = DateTime.now();
                                  attempts.add("${ipv4}/${date}/true");
                                  attempts = attempts.reversed.toList();
                                  await add.addLoginAttempt(login, attempts);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoggedIn(user: login)));
                                } else {
                                  usAttempts;
                                  await ip.updateAttempts(usAttempts, ipv4);
                                  date = DateTime.now();
                                  attempts.add("${ipv4}/${date}/false");
                                  attempts = attempts.reversed.toList();
                                  await add.addLoginAttempt(login, attempts);
                                  Fluttertoast.showToast(
                                    toastLength: Toast.LENGTH_SHORT,
                                    msg: 'Something went wrong',
                                    webBgColor: '#FF0000',
                                    textColor: Colors.white,
                                    webPosition: 'center',
                                  );
                                }
                              }
                            } else {
                              Fluttertoast.showToast(
                                toastLength: Toast.LENGTH_SHORT,
                                msg: 'Something went wrong',
                                webBgColor: '#FF0000',
                                textColor: Colors.white,
                                webPosition: 'center',
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 8,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              color: Colors.transparent,
                              border: Border.all(
                                width: 5,
                                color: Colors.white,
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                            ),
                          ),
                          onTap: () {
                            context.go('/register');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
