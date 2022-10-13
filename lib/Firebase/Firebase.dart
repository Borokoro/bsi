import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserToDatabase {

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");

  Future<void> updateUserData(String login, String pass, String salt) async { //metoda dodania dokumentu
    return await userCollection //stworzenie dokumentu i zapisanie do niego wartosci
        .doc(login)
        .set({'login': login, 'pass': pass, 'salt': salt});
  }
}

class GetUserFromDatabase{

}