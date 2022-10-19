import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoggedIn extends StatefulWidget {

  final String user;
  const LoggedIn({required this.user});
  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  List<String> hashedPass=<String>[];
  List<String> salt=<String>[];
  List<String> which=<String>[];

  Future<void> getHashedPass() async{
    var snapshot= await FirebaseFirestore.instance
        .collection("users").where("users",isEqualTo: widget.user)
        .get();
    snapshot.docs.map((doc){
      hashedPass=List.from(doc.data().toString().contains('extraHashedPass') ? doc.get('extraHashedPass') : null);
    });
  }

  Future<void> getSalt() async{
    var snapshot= await FirebaseFirestore.instance
        .collection("users").where("users",isEqualTo: widget.user)
        .get();
    snapshot.docs.map((doc){
      salt=List.from(doc.data().toString().contains('extraSalt') ? doc.get('extraSalt') : null);
    });
  }

  Future<void> getWhich() async{
    var snapshot= await FirebaseFirestore.instance
        .collection("users").where("users",isEqualTo: widget.user)
        .get();
    snapshot.docs.map((doc){
      which=List.from(doc.data().toString().contains('extraWhich') ? doc.get('extraWhich') : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
              ],
            ),
          ],
        ),
      ),
    );
  }
}
