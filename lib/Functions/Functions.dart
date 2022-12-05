
import 'dart:convert';
import 'dart:math';
import 'package:bsi/Pepper.dart' as variable;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypts;
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

  String decrypt(String salt, String pom){
    var iv=encrypts.IV.fromLength(16);
    encrypts.Encrypted encrypted=encrypts.Encrypted.from64(pom);
    var key=encrypts.Key.fromUtf8(salt);
    var encrypter=encrypts.Encrypter(encrypts.AES(key));
    return encrypter.decrypt(encrypted, iv: iv);
  }

  String encrypt(String varPass, String varSalt){
    var iv=encrypts.IV.fromLength(16);
    var key=encrypts.Key.fromUtf8(varSalt);
    var enc=encrypts.Encrypter(encrypts.AES(key));
    return enc.encrypt(varPass, iv: iv).base64;
  }

}