import 'package:flutter/material.dart';
import 'package:bsi/Firebase/sharedPass.dart';
import 'package:bsi/Firebase/Firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassFromList extends StatefulWidget {
  final String password;
  ChangePassFromList({required this.password});

  @override
  State<ChangePassFromList> createState() => _ChangePassFromListState();
}

class _ChangePassFromListState extends State<ChangePassFromList> {
  final myController=TextEditingController();
  @override
  void initState() {
    myController.text=widget.password;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change password'),
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
                  onPressed: () {
                    Navigator.pop(context, myController.text);
                  },
                  child: Text('Change'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

