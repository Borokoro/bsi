

import 'package:bsi/Firebase/Firebase.dart';
import 'package:flutter/material.dart';
import 'Widgets.dart';

class Logs extends StatefulWidget {
  final String user;
  Logs({required this.user});
  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {


  List<String> attempts=<String>[];
  List<String> attemptsEdit=<String>[];
  List<String> attemptsDelete=<String>[];
  List<String> attemptsAdd=<String>[];
  List<String> attemptsShare=<String>[];
  List<bool> successful=<bool>[];
  List<String> ipList=<String>[];
  List<DateTime> date=<DateTime>[];
  List<String> toButtons=['Login', 'Edit', 'Delete', 'Add', 'Share'];
  int whereAmI=0;
  List<String> ipListEdit=<String>[];
  List<DateTime> dateEdit=<DateTime>[];
  List<String> ipListDelete=<String>[];
  List<DateTime> dateDelete=<DateTime>[];
  List<String> ipListAdd=<String>[];
  List<DateTime> dateAdd=<DateTime>[];
  List<String> ipListShare=<String>[];
  List<DateTime> dateShare=<DateTime>[];
  final Widgets w=Widgets();
  final GetUserFromDatabase gt=GetUserFromDatabase();
  final IpAdresses ip=IpAdresses();

  @override
  void initState() {
      WidgetsFlutterBinding.ensureInitialized();
      executeFunctions(widget.user);
    super.initState();
  }

  Future<void> executeFunctions(String user) async{
    attempts=await ip.getIpAdress(user);
    attempts=attempts.reversed.toList();
    for(int a=0;a<attempts.length;a++){
      final getData=attempts[a].split('/');
      ipList.add(getData[0].toString());
      date.add(DateTime.parse(getData[1]));
      if(getData[2]=="true") {
        successful.add(true);
      } else {
        successful.add(false);
      }
    }

    attemptsEdit=await gt.getEdit(user);
    attemptsEdit=attemptsEdit.reversed.toList();
    for(int a=0;a<attemptsEdit.length;a++){
      final getData=attemptsEdit[a].split('/');
      ipListEdit.add(getData[0].toString());
      dateEdit.add(DateTime.parse(getData[1]));
    }

    attemptsDelete=await gt.getDelete(user);
    attemptsDelete=attemptsDelete.reversed.toList();
    for(int a=0;a<attemptsDelete.length;a++){
      final getData=attemptsDelete[a].split('/');
      ipListDelete.add(getData[0].toString());
      dateDelete.add(DateTime.parse(getData[1]));
    }

    attemptsAdd=await gt.getAdd(user);
    attemptsAdd=attemptsAdd.reversed.toList();
    for(int a=0;a<attemptsAdd.length;a++){
      final getData=attemptsAdd[a].split('/');
      ipListAdd.add(getData[0].toString());
      dateAdd.add(DateTime.parse(getData[1]));
    }

    attemptsShare=await gt.getShare(user);
    attemptsShare=attemptsShare.reversed.toList();
    for(int a=0;a<attemptsShare.length;a++){
      final getData=attemptsShare[a].split('/');
      ipListShare.add(getData[0].toString());
      dateShare.add(DateTime.parse(getData[1]));
    }

  }

  Widget button(int i){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: whereAmI!=i ? Colors.transparent : Colors.blue,
          shape: const StadiumBorder(),
      ),
        onPressed: (){
          setState(() {
            whereAmI=i;
          });
        },
        child: Text(toButtons[i]));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: executeFunctions(widget.user),
      builder: (snap,context){
        return AlertDialog(
          title: const Align( alignment: Alignment.center, child: Text('Logs')),
          contentPadding: const EdgeInsets.all(20.0),
          content: Builder(
            builder: (context){
              var height =MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                width: width/3,
                height: height/2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for(int i=0;i<5;i++)
                          button(i),
                      ],
                    ),
                    SizedBox(height: 20,),
                    if(whereAmI==0) w.loginLogs(context, successful, ipList, date, attempts),
                    if(whereAmI==1) w.editLogs(context, ipListEdit, dateEdit, attemptsEdit),
                    if(whereAmI==2) w.deleteLogs(context, ipListDelete, dateDelete, attemptsDelete),
                    if(whereAmI==3) w.addLogs(context, ipListAdd, dateAdd, attemptsAdd),
                    if(whereAmI==4) w.shareLogs(context, ipListShare, dateShare, attemptsShare),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

