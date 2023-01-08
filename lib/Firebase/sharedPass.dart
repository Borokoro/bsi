import 'package:cloud_firestore/cloud_firestore.dart';
class SharedPass{
  final CollectionReference passCollection =
  FirebaseFirestore.instance.collection("sharedPass");
  Future<void> setPasswords(String login, List<String> pass, List<String> salt) async {
    return await passCollection
        .doc(login)
        .set({'login':login, 'passwords':pass, 'salts':salt});
  }

  Future<List<String>> getSharedPass(String user) async {
    List<dynamic> pomList=<dynamic>[];
    await FirebaseFirestore.instance
        .collection("sharedPass")
        .where("login", isEqualTo: user)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        pomList = element["passwords"];
      })
    });
    return pomList.map((e) => e.toString()).toList();
  }

  Future<List<String>> getSharedSalt(String user) async {
    List<dynamic> pomList=<dynamic>[];
    await FirebaseFirestore.instance
        .collection("sharedPass")
        .where("login", isEqualTo: user)
        .get()
        .then((QuerySnapshot result) => {
      result.docs.forEach((element) {
        pomList = element["salts"];
      })
    });
    return pomList.map((e) => e.toString()).toList();
  }
}