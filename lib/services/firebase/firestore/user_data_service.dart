import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(String uid, String name, String email) async {
    await userCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
    print("Saved user data");
  }
}
