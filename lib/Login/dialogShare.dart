import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:bsi/Firebase/sharedPass.dart';
import 'package:bsi/Firebase/Firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DialogShare extends StatefulWidget {
  final String passwordToShare;
  final String saltToShare;
  final List<String> attemptsShare;
  final String user;
  DialogShare({required this.passwordToShare, required this.saltToShare, required this.attemptsShare, required this.user});

  @override
  State<DialogShare> createState() => _DialogShareState();
}

class _DialogShareState extends State<DialogShare> {
  final myController=TextEditingController();
  final AddUserToDatabase db=AddUserToDatabase();
  List<String> password=<String>[];
  List<String> salt=<String>[];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Who do you want to share it with?'),
      contentPadding: const EdgeInsets.all(20.0),
      content: Builder(
        builder: (context){
          var height =MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width/5,
            height: height/5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: myController,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async{
                    if(await GetUserFromDatabase().doesUserExist(myController.text)) {
                      password=await SharedPass().getSharedPass(myController.text);
                      salt=await SharedPass().getSharedSalt(myController.text);
                      password.add(widget.passwordToShare);
                      salt.add(widget.saltToShare);
                      await SharedPass().setPasswords(myController.text, password, salt);
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_SHORT,
                        msg: 'Password Shared!',
                        webBgColor: '#00FF00',
                        textColor: Colors.white,
                        webPosition: 'center',
                      );
                      Navigator.of(context).pop();
                    }
                    else{
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_SHORT,
                        msg: "User doesn't exist",
                        webBgColor: '#FF0000',
                        textColor: Colors.white,
                        webPosition: 'center',
                      );
                    }
                    String ipv4 = await Ipify.ipv4();
                    DateTime date = DateTime.now();
                    widget.attemptsShare.add('$ipv4/$date');
                    await db.addShareAttempt(widget.user, widget.attemptsShare);
                  },
                  child: Text('Share'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

