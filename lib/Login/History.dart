import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'LoggedIn.dart';
import 'package:bsi/Firebase/Firebase.dart';
import 'variables.dart';
import 'package:bsi/Functions/Functions.dart';

class History{
  final String user;
  final ValueChanged<int> update;
  final int i;
  List<String> passwords=<String>[];
  List<String> passwordsDecrypted=<String>[];
  History({required this.user, required this.i, required this.update});
  final _popupMenu = GlobalKey<PopupMenuButtonState>();
  final Functions f=Functions();

  void executeFunctions(){
    passwords=Variables.passHistoryList[i].split('#');
    if(passwords.isNotEmpty){
      passwords.removeLast();
    }
    for(int a=0;a<passwords.length;a++){
      passwordsDecrypted.add(f.decrypt(Variables.salt[i], passwords[a]));
    }
    print(passwordsDecrypted.length);
  }

  Widget popButton(BuildContext context){
    return Container(
      width: 72,
      height: 60,
      child: Theme(
        data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent,
        ),
        child: PopupMenuButton(
          shape: const RoundedRectangleBorder(),
              padding: const EdgeInsets.all(20),
              key: _popupMenu,
              itemBuilder: (BuildContext context) => [
                for(int a=0;a<passwordsDecrypted.length;a++)
                  PopupMenuItem(
                      value: a,
                      child: Text(passwordsDecrypted[a])),
              ],
            onCanceled: (){
              passwordsDecrypted=<String>[];
            },
            onSelected: (value) async{
            String valueAtHash=passwords[value];
            passwords.removeAt(value);
            String pom="";
            for(int a=0; a<passwords.length;a++){
              pom='$pom${passwords[a]}#';
            }
            Variables.passHistoryList[i]='$pom${Variables.hashedPass[i]}#';
            Variables.hashedPass[i]=valueAtHash;
            List<String> toDatabase=<String>[];
            for(int a=0;a<Variables.passHistoryList.length;a++){
              toDatabase.add('${Variables.hashedPass[a]}#${Variables.passHistoryList[a]}');
            }
            await AddUserToDatabase().changePass(user, toDatabase, Variables.salt);
            String ipv4 = await Ipify.ipv4();
            DateTime date = DateTime.now();
            Variables.attemptsEdit.add('$ipv4/$date');
            await AddUserToDatabase().addEditAttempt(user, Variables.attemptsEdit);
            update(i);
            },
            child: ElevatedButton.icon(
            onPressed: (){
              executeFunctions();
              _popupMenu.currentState?.showButtonMenu();
            },
              icon:const Icon(Icons.menu_book_rounded),
              label: Text(''),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
        ),
        ),
      ),
    );
  }
}