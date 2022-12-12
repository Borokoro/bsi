import 'dart:convert';
import 'dart:math';
import 'package:bsi/Login/ChangePass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:bsi/Pepper.dart' as variable;
import 'package:bsi/Firebase/Firebase.dart';
import 'package:go_router/go_router.dart';
import 'package:bsi/Functions/Functions.dart';
import 'Logs.dart';

class LoggedIn extends StatefulWidget {
  final String user;
  const LoggedIn({super.key, required this.user});
  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  List<String> hashedPass = <String>[];
  List<String> salt = <String>[];
  List<String> pom = <String>[];
  List<dynamic> pomList = <dynamic>[];
  String newPass = "";
  String newSalt = "";
  bool? first = true, second = false;
  Color visible = Colors.red;
  List<bool> passVisible = <bool>[];
  Functions f = Functions();

  @override
  initState() {
    executeFunctions();
    super.initState();
  }

  void executeFunctions() async {
    await getHashedPass();
    await getSalt();
    setState(() {});
  }

  Future<void> getHashedPass() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("login", isEqualTo: widget.user)
        .get()
        .then((QuerySnapshot result) => {
              result.docs.forEach((element) {
                pomList = element["extraPass"];
              })
            });
    hashedPass = pomList.map((e) => e.toString()).toList();
    pom=[...hashedPass];
    for (int a = 0; a < hashedPass.length; a++) {
      passVisible.add(false);
    }
  }

  Future<void> getSalt() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("login", isEqualTo: widget.user)
        .get()
        .then((QuerySnapshot result) => {
              result.docs.forEach((element) {
                pomList = element["extraSalt"];
              })
            });
    salt = pomList.map((e) => e.toString()).toList();
  }

  String hash_sha512(String password, String varSalt) {
    String? hashedPass512;
    hashedPass512 = sha512
        .convert(utf8.encode(password + varSalt + variable.pepper))
        .toString();
    return hashedPass512;
  }

  String hash_HMAC() {
    String? hashed_pass;
    hashed_pass = Hmac(sha512, utf8.encode(newSalt))
        .convert(utf8.encode(newPass + variable.pepper))
        .toString();
    return hashed_pass;
  }

  String salt_generate() {
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
          body: ListView(
            children: [
              const SizedBox(height: 20,),
              for (int a = 0; a < salt.length; a++)
                Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 20,
                        child: Text(
                          '${a + 1}:   ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        width: 800,
                        child: Text(
                          '    ${pom[a]}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 72,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if(passVisible[a]==false){
                              setState(() {
                                passVisible[a]=true;
                                pom[a]=f.decrypt(salt[a],pom[a]);
                              });
                            }
                            else{
                              setState(() {
                                passVisible[a]=false;
                                pom[a]=f.encrypt(pom[a],salt[a]);
                              });
                            }
                          },
                          icon: passVisible[a] == false
                              ? const Icon(Icons.admin_panel_settings)
                              : const Icon(Icons.admin_panel_settings_outlined),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: passVisible[a] == false
                                ? Colors.transparent
                                : Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          label: const Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Enter new password:',
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
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 40),
                        onChanged: (val) {
                          setState(() {
                            newPass = val.trim();
                          });
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      newSalt = salt_generate();
                      salt.add(newSalt);
                      newPass=f.encrypt(newPass, newSalt);
                      hashedPass.add(newPass);
                      await AddUserToDatabase().addNewPass(widget.user, hashedPass, salt);
                      for(int a=0; a<passVisible.length;a++){
                        passVisible[a]=false;
                      }
                      passVisible.add(false);
                      setState(() {
                        pom=[...hashedPass];
                        print(pom.length);
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 14,
                      height: 60,
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
                          '+',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            const Text(
                              'Change',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePass(user: widget.user)));
                    },
                  ),
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
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            const Text(
                              'See',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                            const Text(
                              'Logs',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context) => Logs(user: widget.user,),
                      );
                    },
                  ),
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
                          'Log out',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                        ),
                      ),
                    ),
                    onTap: (){
                      GoRouter.of(context).push('/');
                    },
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
