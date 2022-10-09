import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserToDatabase {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users"); //odwołanie do kolekcji w Firebase

  Future<void> updateUserData(String login, String pass) async { //metoda dodania dokumentu
    return await userCollection //stworzenie dokumentu i zapisanie do niego wartosci
        .doc(login)
        .set({'login': login, 'pass': pass});
  }
}