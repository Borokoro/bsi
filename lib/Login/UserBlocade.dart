import 'dart:async';

import 'package:captcha_solver/captcha_solver.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_captcha/flutter_number_captcha.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../Firebase/Firebase.dart';

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
  bool blockedBool =true;
  int pom=1;
  IpAdresses ip = IpAdresses();

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

  Future<void> capcha() async{
    String apiKey = '6LdZ444jAAAAABbgSrR2mrkgXqrG-bijGkG7Zak-';
    String websiteURL = 'localhost';
    String websiteKey = '6LdZ444jAAAAAHVoS-007kDjjzmAgbw4QH-csgQ5';
    /// Initiate CaptchaSolver
    CaptchaSolver captchaSolver = CaptchaSolver(apiKey);
    print("jestem");
    /// Example of the request
    Map inputs = {
      "clientKey": apiKey,
      "task": {
        "type": "RecaptchaV2TaskProxyless",
        "websiteURL": websiteURL,
        "websiteKey": websiteKey,
        "isInvisible": false
      }
    };

    /// Get captcha solution
    Map response = await captchaSolver.recaptcha(inputs);
    print("jestem");
    print('response: $response');
    if(response['status']=='ready') {
      print(response['solution']['gRecaptchaResponse']);
    }
  }

  Widget banned(BuildContext context, var height, var width) {
      return Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.network('https://assets1.lottiefiles.com/packages/lf20_pnycfvl3.json',
              width: 150,
              height: 150,
              frameRate: FrameRate.max,
              fit: BoxFit.fitHeight,
            ),
            Text(blockedBool==true ? 'This ip is blocked' : 'Ip unlocked!'),
            ElevatedButton(
              onPressed: () async{
                if(blockedBool==true) {
                String ipv4 = await Ipify.ipv4();
                bool isValid = await FlutterNumberCaptcha.show(
                  context,
                  titleText: 'Enter correct number',
                  placeholderText: 'Enter Number',
                  checkCaption: 'Check',
                  accentColor: Colors.blue,
                  invalidText: 'Invalid code',
                );
                if (isValid) {
                  await ip.updateAttempts(0, ipv4);
                  setState(() {
                    blockedBool = false;
                  });
                }
                else{
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_SHORT,
                    msg: 'Wrong number!',
                    webBgColor: '#FF0000',
                    textColor: Colors.white,
                    webPosition: 'center',
                  );
                }
              }
                else {
                  null;
                }
            },
              child: Text(blockedBool==true ? 'Unlock ip' : 'Ip unlocked'),
            ),

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
              width: 150,
              height: 150,
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
