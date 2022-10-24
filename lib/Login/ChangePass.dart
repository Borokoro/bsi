import 'dart:convert';
import 'dart:math';
import 'package:bsi/Pepper.dart' as variable;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Firebase/Firebase.dart';
import 'LoggedIn.dart';

class ChangePass extends StatefulWidget {

  final String user;
  const ChangePass({super.key, required this.user});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String login = "";
  String pass = "";
  String salt="";
  bool? first=true, second=false;
  String password="";
  String which="";
  String passPom="";

  String hash_sha512(){
    String? hashed_pass;
    hashed_pass=sha512.convert(utf8.encode(login+salt+variable.pepper)).toString();
    return hashed_pass;
  }
  Future<bool> checkPassword() async{
    password=await GetUserFromDatabase().getPass(widget.user);
    which =await GetUserFromDatabase().getWhich(widget.user);
    salt=await GetUserFromDatabase().getSalt(widget.user);
    passPom=login;
    if(which=='sha512'){
      passPom=hash_sha512();
    }
    else{
      passPom=hash_HMAC();
    }
    if(passPom==password) {
      print('prawda');
      return true;
    } else {
      print('falsz');
      return false;
    }
  }
  String hash_HMAC(){
    String? hashed_pass;
    hashed_pass=Hmac(sha512, utf8.encode(salt)).convert(utf8.encode(login+variable.pepper)).toString();
    return hashed_pass;
  }
  String hash_HMAC1(){
    String? hashed_pass;
    hashed_pass=Hmac(sha512, utf8.encode(salt)).convert(utf8.encode(pass+variable.pepper)).toString();
    return hashed_pass;
  }
  String hash_sha5121(){
    String? hashed_pass;
    hashed_pass=sha512.convert(utf8.encode(pass+salt+variable.pepper)).toString();
    return hashed_pass;
  }
  String salt_generate(){
    Random rnd = Random();
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#%^&*';
    String randomString = String.fromCharCodes(List.generate(
        32, (index) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    return randomString;
  }

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
                'Enter new password',
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
                    'Enter old password: ',
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
                        obscureText: true,
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
                    'Enter new password: ',
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
                          'Change',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                        ),
                      ),
                    ),
                    onTap: () async{
                      if(await checkPassword()==true) {
                          salt = salt_generate();
                          if (first == true) {
                            await AddUserToDatabase().updateUserData(
                                widget.user, hash_sha5121(), salt, "sha512");
                          } else if (second == true) {
                            await AddUserToDatabase().updateUserData(widget.user,
                                hash_HMAC1(), salt, "HMAC");
                          }

                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            msg: 'Password changed',
                            webBgColor: '#00FF00',
                            textColor: Colors.white,
                            webPosition: 'center',
                          );
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
                          'Back',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoggedIn(user: widget.user)));
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
