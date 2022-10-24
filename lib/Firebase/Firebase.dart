import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserToDatabase {
  List<String> pom=<String>[];
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");

  Future<void> setUserData(String login, String pass, String salt, String which) async { //metoda dodania dokumentu
    return await userCollection //stworzenie dokumentu i zapisanie do niego wartosci
        .doc(login)
        .set({'login': login, 'pass': pass, 'salt': salt, 'which': which, 'extraPass':pom, 'extraSalt':pom,});
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
    print(documents.length);
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