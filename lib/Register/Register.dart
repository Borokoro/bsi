import 'dart:convert';

import 'package:bsi/Firebase/Firebase.dart';
import 'package:flutter/material.dart';
import 'package:bsi/Login/Login.dart';
import 'package:crypto/crypto.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String login = "";
  String pass = "";
  bool? first=true, second=false;
  var passh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width/3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Regiser',
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
                        style: const TextStyle(color: Colors.black, fontSize: 30),
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
                        style: const TextStyle(color: Colors.black, fontSize: 30),
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
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    child: CheckboxListTile(
                      title: const Text("SHA512"),
                      value: first,
                      onChanged: (newValue) {
                        setState(() {
                          first = newValue;
                          if(second==true) {
                            second=false;
                          } else {
                            second=true;
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Container(
                    width: 150,
                    child: CheckboxListTile(
                      title: const Text("HMAC"),
                      value: second,
                      onChanged: (newValue) {
                        setState(() {
                          second = newValue;
                          if(first==true) {
                            first=false;
                          } else {
                            first=true;
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.platform,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width/8,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Colors.transparent,
                        border: Border.all(
                          width: 5,
                          color: Colors.white,
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                        ),
                      ),
                    ),
                    onTap: () async{
                      if(first==true) {
                        await AddUserToDatabase().updateUserData(login, sha512.convert(utf8.encode(pass)).toString());
                      } else if(second==true) {
                        List<int> messageBytes = utf8.encode(pass);
                        Hmac hmac = Hmac(sha256, base64.decode('I dont know'));
                        await AddUserToDatabase().updateUserData(login, base64.encode(hmac.convert(messageBytes).bytes));
                      }
                    },
                  ),
                  const SizedBox(width: 40,),
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width/8,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Colors.transparent,
                        border: Border.all(
                          width: 5,
                          color: Colors.white,
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
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
