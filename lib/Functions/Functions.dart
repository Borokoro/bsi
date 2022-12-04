
import 'dart:convert';
import 'dart:math';
import 'package:bsi/Pepper.dart' as variable;
import 'package:crypto/crypto.dart';

class Functions{
  String hashSha512(String salt, String pass) {
    String? hashedPass;
    hashedPass =
        sha512.convert(utf8.encode(pass + salt + variable.pepper)).toString();
    return hashedPass;
  }

  String hashHMAC(String salt, String pass){
    String? hashedPass;
    hashedPass=Hmac(sha512, utf8.encode(salt)).convert(utf8.encode(pass + variable.pepper)).toString();
    return hashedPass;
  }

  String salt_generate(){
    Random rnd = Random();
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#%^&*';
    String randomString = String.fromCharCodes(List.generate(
        32, (index) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    return randomString;
  }
}