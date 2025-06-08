import 'package:flutter/material.dart';

class Room {
  final String code;
  final String name;
  final String category;
  final String technician;
  final String phoneNumber;
  final Color tagColor;
  final String tagText;

  Room({
    required this.code,
    required this.name,
    required this.category,
    required this.technician,
    required this.phoneNumber,
    required this.tagColor,
    required this.tagText,
  });

  // Factory constructor untuk membuat instance Room dari data Firestore
  factory Room.fromFirestore(Map<String, dynamic> data) {
    // Fungsi untuk mengubah String Hex (e.g., "8A9BFF") menjadi Color
    Color hexToColor(String hexCode) {
      final buffer = StringBuffer();
      if (hexCode.length == 6 || hexCode.length == 7) buffer.write('ff');
      buffer.write(hexCode.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }

    return Room(
      code: data['code'],
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      technician: data['technician'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      tagColor: hexToColor(data['tagColor'] ?? '808080'),
      tagText: data['tagText'] ?? '',
    );
  }
}
