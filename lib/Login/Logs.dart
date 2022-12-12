

import 'package:bsi/Firebase/Firebase.dart';
import 'package:flutter/material.dart';

class Logs extends StatefulWidget {
  final String user;
  Logs({required this.user});
  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {


  List<String> attempts=<String>[];
  List<bool> successful=<bool>[];
  List<String> ipList=<String>[];
  List<DateTime> date=<DateTime>[];

  final IpAdresses ip=IpAdresses();

  @override
  void initState() {
      WidgetsFlutterBinding.ensureInitialized();
      executeFunctions(widget.user);
    super.initState();
  }

  Future<void> executeFunctions(String user) async{
    attempts=await ip.getIpAdress(user);
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
    print(ipList[0]);
  }
  Widget everything(BuildContext context){
    print(ipList.length);
    return ListView(
      children: [
        for(int a=0;a<attempts.length;a++)
          Container(
            height: MediaQuery.of(context).size.height/14,
            width: MediaQuery.of(context).size.width/10,
            decoration: BoxDecoration(
              color: successful[a]==true ? Colors.green : Colors.red,
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //const SizedBox(width: 0.1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      ipList[a],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      date[a].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  successful[a]==true ? 'successful' : 'unsucessfull',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
               // const SizedBox(width: 1,),
              ],
            ),
          ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: executeFunctions(widget.user),
      builder: (snap,context){
        return AlertDialog(
          title: const Text('Last login attempts'),
          contentPadding: const EdgeInsets.all(20.0),
          content: Builder(
            builder: (context){
              var height =MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                width: width/3,
                height: height/3,
                child: everything(context),
              );
            },
          ),
        );
      },
    );
  }
}

