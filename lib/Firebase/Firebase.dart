import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserToDatabase {
  List<String> pom=<String>[];
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");

  Future<void> setUserData(String login, String pass, String salt, String which) async { //metoda dodania dokumentu
    return await userCollection //stworzenie dokumentu i zapisanie do niego wartosci
        .doc(login)
        .set({'login': login, 'pass': pass, 'salt': salt, 'which': which, 'extraPass':pom, 'extraSalt':pom, 'loginAttempts': pom, 'blockedIp':pom,});
  }

  Future<void> updateUserData(String login, String pass, String salt, String which) async { //metoda dodania dokumentu
    return await userCollection //stworzenie dokumentu i zapisanie do niego wartosci
        .doc(login)
        .update({'login': login, 'pass': pass, 'salt': salt, 'which': which,});
  }


  Future<void> addNewPass(String login, List<String> pass, List<String> salt) async{
    return await userCollection.doc(login)
        .update({"extraPass":FieldValue.arrayUnion(pass),
              "extraSalt":FieldValue.arrayUnion(salt),
        });
  }

  Future<void> addLoginAttempt(String login, List<String> attempts) async{
    return await userCollection.doc(login)
        .update({"loginAttempts":FieldValue.arrayUnion(attempts),
    });
  }
}

class GetUserFromDatabase{

  Future<bool> doesUserExist(String user) async{
    final QuerySnapshot result=await FirebaseFirestore.instance
        .collection("users")
        .where("login", isEqualTo: user)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents;
    documents=result.docs;
    if(documents.length==1) {
      return true;
    } else {
      return false;
    }
  }
  Future<String> getSalt(String user) async{
    String salt="";
    await FirebaseFirestore.instance
          .collection("users")
    .where("login", isEqualTo: user)
    .get()
    .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        salt=element["salt"];
      })
    });
    return salt;
  }
  Future<String> getWhich(String user) async{
    String which="";
    await FirebaseFirestore.instance
        .collection("users")
        .where("login", isEqualTo: user)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        which=element["which"];
      })
    });
    return which;
  }
  Future<String> getPass(String user) async{
    String pass="";
    await FirebaseFirestore.instance
        .collection("users")
        .where("login", isEqualTo: user)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        pass=element["pass"];
      })
    });
    return pass;
  }
}

class IpAdresses{
  final CollectionReference ipCollection =
  FirebaseFirestore.instance.collection("ipAdresses");

  Future<void> setIpAdress(String ip, int usAttempts) async { //metoda dodania dokumentu
    return await ipCollection //stworzenie dokumentu i zapisanie do niego wartosci
        .doc(ip)
        .set({'ip': ip, 'usAttempts': usAttempts,});
  }

  Future<Timestamp> getLastAttempt(String unickId) async{
    late Timestamp pom;
    await FirebaseFirestore.instance
        .collection("ipAdresses")
        .where("ip", isEqualTo: unickId)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        pom=element["lastAttempt"];
      })
    });
    return pom;
  }

  Future<int> getUsAteempts(String unickId) async{
    late int pom;
    await FirebaseFirestore.instance
        .collection("ipAdresses")
        .where("ip", isEqualTo: unickId)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        pom=element["usAttempts"];
      })
    });
    return pom;
  }

  Future<List<String>> getIpAdress(String user) async {
    List<dynamic> pomList=<dynamic>[];
    await FirebaseFirestore.instance
        .collection("users")
        .where("login", isEqualTo: user)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        pomList = element["loginAttempts"];
      })
    });
    return pomList.map((e) => e.toString()).toList();
  }

  Future<void> updateAttempts(int attempts, String ip) async{
    return await ipCollection.doc(ip)
        .update({"usAttempts":attempts,
    });
  }

  Future<bool> doesIpExist(String ip) async{
    final QuerySnapshot result=await FirebaseFirestore.instance
        .collection("ipAdresses")
        .where("ip", isEqualTo: ip)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents;
    documents=result.docs;
    if(documents.length==1) {
      return true;
    } else {
      return false;
    }
  }
}