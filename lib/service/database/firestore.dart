import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:resif/models/booking.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/models/rules.dart';

class FirestoreService {
  // get collection of users
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  final CollectionReference bookingForm =
      FirebaseFirestore.instance.collection('bookings');

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
    String? department,
    String? photoUrl,
  ) async {
    await users.doc(email).set({
      'createdAt': DateTime.now(),
      'name': name,
      'email': email,
      'password': hashPassword(password),
      'phone': phone ?? '',
      'department': department ?? '',
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
    String? department,
    String? photoUrl,
  ) async {
    await users.doc(email).update({
      'name': name,
      'phone': phone,
      'department': department,
      'photoUrl': photoUrl,
    });
  }

  // fetch all rules from Firestore
  Future<List<Rules>> fetchAllRules() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('rules').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      // Ubah setiap dokumen menjadi objek Rules
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Logika ini menangani jika 'content' adalah List atau String tunggal
        final dynamic contentData = data['content'];
        List<String> contentList = [];

        if (contentData is List) {
          // Jika sudah berupa list, konversi langsung
          contentList = List<String>.from(contentData);
        } else if (contentData is String) {
          // Jika hanya string, bungkus menjadi list berisi satu item
          contentList = [contentData];
        }

        return Rules(
          id: doc.id,
          title: data['title'],
          content: contentList,
        );
      }).toList();
    } catch (e) {
      print("Error fetching rule sections: $e");
      throw Exception("Gagal memuat data dari server.");
    }
  }

  // fetch all rooms from Firestore
  Future<List<Room>> fetchRooms() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        return Room.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching rooms: $e");
      throw Exception("Gagal memuat data ruangan.");
    }
  }

  Future<void> addBooking(BookingModel booking) {
    return bookingForm.add(booking.toMap());
  }

  // NEW: Method to fetch all bookings
  Future<List<BookingModel>> fetchBookings() async {
    try {
      QuerySnapshot snapshot = await bookingForm
          .orderBy('createdAt', descending: true) // Show newest first
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>,
            id: doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching bookings: $e");
      throw Exception("Gagal memuat data booking.");
    }
  }
}
