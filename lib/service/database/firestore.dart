import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class FirestoreService {
  // get collection of users
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  // hash password
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // save user data to db firestore
  Future<void> saveUserDataToDatabase(
    String name,
    String email,
    String password,
    String? phone,
    String? job,
    String? photoUrl,
  ) async {
    await users.doc(email).set({
      'createdAt': DateTime.now(),
      'name': name,
      'email': email,
      'password': hashPassword(password),
      'phone': phone ?? '',
      'job': job ?? '',
      'photoUrl': photoUrl ?? '',
    });
  }

  // get user data by email
  Future<Map<String, dynamic>?> getUserDataByEmail(String email) async {
    final querySnapshot = await users.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    }
    return null;
  }

  // update user data
  Future<void> updateUserData(
    String email,
    String name,
    String? phone,
    String? job,
    String? photoUrl,
  ) async {
    await users.doc(email).update({
      'name': name,
      'phone': phone,
      'job': job,
      'photoUrl': photoUrl,
    });
  }
}
