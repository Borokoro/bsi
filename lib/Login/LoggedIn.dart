import 'dart:convert';
import 'dart:math';
import 'package:bsi/Login/ChangePass.dart';
import 'package:bsi/Login/History.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:bsi/Pepper.dart' as variable;
import 'package:bsi/Firebase/Firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:bsi/Functions/Functions.dart';
import 'Logs/Logs.dart';
import 'package:bsi/Firebase/sharedPass.dart';
import 'dialogShare.dart';
import 'changePassFromList.dart';
import 'variables.dart';

class LoggedIn extends StatefulWidget {
  final String user;
  const LoggedIn({super.key, required this.user});
  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  String ipv4="nie";
  List<String> attemptsDelete=<String>[];
  List<String> attemptsAdd=<String>[];
  List<String> attemptsShare=<String>[];
  

  List<String> sharedSalt = <String>[];
  List<String> pom = <String>[];
  List<String> sharedPassList = <String>[];
  List<String> deSharedPassList = <String>[];
  
  List<dynamic> pomList = <dynamic>[];
  String newPass = "";
  String newSalt = "";
  bool? first = true, second = false;
  Color visible = Colors.red;
  List<bool> passVisible = <bool>[];
  List<bool> sharedPassVisible = <bool>[];
  List<String> getter=<String>[];
  Functions f = Functions();
  AddUserToDatabase db=AddUserToDatabase();
  final GetUserFromDatabase gt=GetUserFromDatabase();
  bool readMode = true;
  DateTime date=DateTime.now();

  @override
  initState() {
    print('i ja tez');
    executeFunctions();
    super.initState();
  }
  void _update(int something){
    setState(() {
      passVisible[something]=false;
      pom = [...Variables.hashedPass];
    });
  }
  void executeFunctions() async {
    await getHashedPass();
    await getSalt();
    sharedPassList = await SharedPass().getSharedPass(widget.user);
    sharedSalt = await SharedPass().getSharedSalt(widget.user);
    deSharedPassList = [...sharedPassList];
    for (int a = 0; a < sharedPassList.length; a++) {
      sharedPassVisible.add(false);
    }
    Variables.attemptsEdit=await gt.getEdit(widget.user);
    attemptsDelete=await gt.getDelete(widget.user);
    attemptsShare=await gt.getShare(widget.user);
    attemptsAdd=await gt.getAdd(widget.user);
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
    getter= pomList.map((e) => e.toString()).toList();
    print(getter.length);
    Variables.hashedPass=List<String>.generate(getter.length, (index) => '');
    Variables.passHistoryList=List<String>.generate(getter.length, (index) => '');
    for(int a=0;a<getter.length;a++){
      if(getter[a].contains('#')) {
        final getData = getter[a].split('#');
        Variables.hashedPass[a]=getData[0].toString();
        print(getData.length);
        for (int i = 1; i < getData.length-1; i++) {
          Variables.passHistoryList[a] = '${Variables.passHistoryList[a]}${getData[i]}#';
        }
      }
      else{
        Variables.hashedPass[a]=getter[a];
      }
    }
    pom = [...Variables.hashedPass];
    for (int a = 0; a < Variables.hashedPass.length; a++) {
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
    Variables.salt = pomList.map((e) => e.toString()).toList();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                readMode == true
                    ? 'You are in read mode '
                    : 'You are in edit mode ',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    readMode = !readMode;
                  });
                },
                icon: readMode == false
                    ? const Icon(Icons.mode_edit_outline_outlined)
                    : const Icon(Icons.remove_red_eye_outlined),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor:
                      readMode == false ? Colors.red : Colors.transparent,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                label: const Text(""),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Passwords: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          for (int a = 0; a < Variables.salt.length; a++)
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
                  Row(
                    children: [
                      //NOWE GUZIKI TAK ZEBYS JE ZNALZL
                      Container(
                        width: 72,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: readMode==false ? () async{
                            String? getValue;
                            getValue=await showDialog<String>(
                              context: context,
                              builder: (context) => ChangePassFromList(
                                password: f.decrypt(Variables.salt[a], Variables.hashedPass[a]),
                              ),
                            );
                            ipv4 = await Ipify.ipv4();
                            date = DateTime.now();
                            Variables.attemptsEdit.add('$ipv4/$date');
                            await db.addEditAttempt(widget.user, Variables.attemptsEdit);
                            String pomocnicza=Variables.hashedPass[a];
                            Variables.hashedPass[a]='${f.encrypt(getValue!, Variables.salt[a])}#$pomocnicza#${Variables.passHistoryList[a]}';
                            //print(Variables.hashedPass[a]);
                            pom[a]=Variables.hashedPass[a];
                            getter[a]=Variables.hashedPass[a];
                            await AddUserToDatabase().changePass(widget.user, getter, Variables.salt);
                            await getHashedPass();
                            setState(() {
                            });
                          } : (){
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              msg: "“you have to switch to the edit mode to edit password",
                              webBgColor: '#FF0000',
                              textColor: Colors.white,
                              webPosition: 'center',
                            );
                          },
                          icon: const Icon(Icons.mode_edit_outline_outlined),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: readMode==false ?  Colors.transparent : Colors.white30,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          label: const Text(""),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 72,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: readMode==false ? () async{
                            Variables.hashedPass.removeAt(a);
                            pom.removeAt(a);
                            Variables.salt.removeAt(a);
                            await AddUserToDatabase().changePass(widget.user, Variables.hashedPass, Variables.salt);
                            ipv4 = await Ipify.ipv4();
                            date = DateTime.now();
                            attemptsDelete.add('$ipv4/$date');
                            await db.addDeleteAttempt(widget.user, Variables.attemptsEdit);
                            setState(() {
                            });
                          } : (){
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              msg: "“you have to switch to the edit mode to delete password",
                              webBgColor: '#FF0000',
                              textColor: Colors.white,
                              webPosition: 'center',
                            );
                          },
                          icon: const Icon(Icons.delete_outline),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: readMode==false ?  Colors.transparent : Colors.white30,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          label: const Text(""),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      History(user: widget.user, i: a, update: _update).popButton(context),
                      //KONIEC NOWQYCH GUZIKOW
                      Container(
                        width: 72,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DialogShare(
                                passwordToShare: Variables.hashedPass[a],
                                saltToShare: Variables.salt[a],
                                attemptsShare: attemptsShare,
                                user: widget.user,
                              ),
                            );
                          },
                          icon: const Icon(Icons.ios_share_outlined),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: Colors.transparent,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          label: const Text(""),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 72,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (passVisible[a] == false) {
                              setState(() {
                                passVisible[a] = true;
                                pom[a] = f.decrypt(Variables.salt[a], pom[a]);
                              });
                            } else {
                              setState(() {
                                passVisible[a] = false;
                                pom[a] = f.encrypt(pom[a], Variables.salt[a]);
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
                ],
              ),
            ),
          const Text(
            'Shared Passwords: ',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          for (int j = 0; j < sharedPassList.length; j++)
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 20,
                    child: Text(
                      '${j + 1}:   ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    width: 800,
                    child: Text(
                      '    ${deSharedPassList[j]}',
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
                        if (sharedPassVisible[j] == false) {
                          setState(() {
                            sharedPassVisible[j] = true;
                            deSharedPassList[j] =
                                f.decrypt(sharedSalt[j], deSharedPassList[j]);
                          });
                        } else {
                          setState(() {
                            sharedPassVisible[j] = false;
                            deSharedPassList[j] = f.encrypt(
                              deSharedPassList[j],
                              sharedSalt[j],
                            );
                          });
                        }
                      },
                      icon: sharedPassVisible[j] == false
                          ? const Icon(Icons.admin_panel_settings)
                          : const Icon(Icons.admin_panel_settings_outlined),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: sharedPassVisible[j] == false
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
          SizedBox(height: 20,),
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
                    style: const TextStyle(color: Colors.black, fontSize: 40),
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
                  Variables.salt.add(newSalt);
                  newPass = f.encrypt(newPass, newSalt);
                  getter.add(newPass);
                  await AddUserToDatabase()
                      .addNewPass(widget.user, getter, Variables.salt);
                  for (int a = 0; a < passVisible.length; a++) {
                    passVisible[a] = false;
                  }
                  passVisible.add(false);
                  ipv4 = await Ipify.ipv4();
                  date = DateTime.now();
                  attemptsAdd.add('$ipv4/$date');
                  await db.addAddAttempt(widget.user, attemptsAdd);
                  await getHashedPass();
                  setState(() {
                    pom = [...Variables.hashedPass];
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 14,
                  height: 60,
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
                  width: MediaQuery.of(context).size.width / 8,
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
                      children: const [
                        Text(
                          'Change',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePass(user: widget.user)));
                },
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width / 8,
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
                      children: const [
                        Text(
                          'See',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Text(
                          'Logs',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Logs(
                      user: widget.user,
                    ),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width / 8,
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
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ),
                onTap: () {
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
