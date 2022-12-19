import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UserBlocade extends StatefulWidget {
  final int usAttempts;
  UserBlocade({required this.usAttempts});

  @override
  State<UserBlocade> createState() => _UserBlocadeState();
}

class _UserBlocadeState extends State<UserBlocade> {
  static const oneSec = Duration(seconds: 1);
  late int blockade;
  late Timer timer;
  int pom=1;

  @override
  void initState() {
    if (widget.usAttempts == 2)
      blockade = 5;
    else if (widget.usAttempts == 3)
      blockade = 10;
    else
      blockade = -1;
    super.initState();
  }

  void startTimer(BuildContext context) {
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (blockade == 0) {
        setState(() {
          timer.cancel();
          Navigator.of(context).pop();
        });
      } else {
        setState(() {
          blockade--;
        });
      }
    });
  }

  Widget banned(BuildContext context, var height, var width) {
      return Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.network('https://assets1.lottiefiles.com/packages/lf20_pnycfvl3.json',
              width: 200,
              height: 200,
              frameRate: FrameRate.max,
              fit: BoxFit.fitHeight,
            ),
            Text('This ip is blocked'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
    );
  }

  Widget blocked(BuildContext context, var height, var width) {
    return Container(
      width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network('https://assets1.lottiefiles.com/packages/lf20_pnycfvl3.json',
              width: 200,
              height: 200,
              frameRate: FrameRate.max,
              fit: BoxFit.fitHeight,
            ),
            Text('Your ip has been blocked for: '),
            Text('$blockade'),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (pom==1 && blockade != -1) {
      pom=0;
      startTimer(context);
    }
    return AlertDialog(
      title: const Text('Too many failed login attempts'),
      contentPadding: const EdgeInsets.all(20.0),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height/3;
          var width = MediaQuery.of(context).size.width/3;
          if (blockade == -1)
            return banned(context, height, width);
          else
            return blocked(context, height, width);
        },
      ),
    );
  }
}
