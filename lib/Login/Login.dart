import 'dart:convert';
import 'LoggedIn.dart';
import 'package:bsi/Firebase/Firebase.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:bsi/Register/Register.dart';
import 'package:bsi/Pepper.dart' as variable;
import 'package:go_router/go_router.dart';
import 'package:bsi/Router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String login = "";
  String pass = "";

  String hash_sha512(String salt) {
    String? hashedPass;
    hashedPass =
        sha512.convert(utf8.encode(pass + salt + variable.pepper)).toString();
    return hashedPass;
  }

  String hash_HMAC(String salt){
    String? hashed_pass;
    hashed_pass=Hmac(sha512, utf8.encode(salt)).convert(utf8.encode(pass + variable.pepper)).toString();
    return hashed_pass;
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                        validator: (val) => val == '' ? 'Enter login' : null,
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                        validator: (val) => val == '' ? 'Enter password' : null,
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
                      bool userExist =
                          await GetUserFromDatabase().doesUserExist(login);
                      if (userExist == true) {
                        String salt =
                            await GetUserFromDatabase().getSalt(login);
                        String password =
                            await GetUserFromDatabase().getPass(login);
                        print(password);
                        if (await GetUserFromDatabase().getWhich(login) ==
                            "sha512") {
                          if (hash_sha512(salt) == password) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoggedIn(user: login)));
                          } else
                            Fluttertoast.showToast(
                              msg: 'Something went wrong',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              gravity: ToastGravity.BOTTOM,
                            );

                        }
                        else{
                          if (hash_HMAC(salt) == password) {
                            print("Dane sie zgadzaja");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoggedIn(user: login)));
                          }
                          else{
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              msg: 'Something went wrong',
                              webBgColor: '#FF0000',
                              textColor: Colors.white,
                              webPosition: 'center',
                            );
                          }
                        }
                      } else
                        Fluttertoast.showToast(
                          toastLength: Toast.LENGTH_SHORT,
                          msg: 'Something went wrong',
                          webBgColor: '#FF0000',
                          textColor: Colors.white,
                          webPosition: 'center',
                        );
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
