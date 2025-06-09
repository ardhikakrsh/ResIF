import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/components/blue_background.dart';
import 'package:resif/components/header.dart';
import 'package:resif/components/room_card.dart';
import 'package:resif/components/search_field.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/service/database/firestore.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirestoreService db = FirestoreService();
  late Future<List<Room>> _roomsFuture;

  // State untuk data, filter, dan search
  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ambil data saat halaman pertama kali dibuka
    _roomsFuture = db.fetchRooms();
    // Tambahkan listener untuk search bar
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // dipanggil setiap kali teks pencarian berubah
  void _onSearchChanged() {
    _filterRooms();
  }

  // Fungsi utama untuk memfilter ruangan
  void _filterRooms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // 1. Filter berdasarkan kategori
      var roomsByCategory = _selectedCategory == 'All'
          ? _allRooms
          : _allRooms
              .where((room) => room.category == _selectedCategory)
              .toList();

      // 2. Filter berdasarkan query pencarian dari hasil filter kategori
      if (query.isNotEmpty) {
        _filteredRooms = roomsByCategory.where((room) {
          final codeMatch = room.code.toLowerCase().contains(query);
          final nameMatch = room.name.toLowerCase().contains(query);
          return codeMatch || nameMatch;
        }).toList();
      } else {
        // Jika tidak ada query, tampilkan hasil filter kategori
        _filteredRooms = roomsByCategory;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlueBackground(height: 150.h),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 30.0.h, left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
                  child: const Header(),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchField(
                              text: 'Search Room',
                              controller: _searchController),
                          SizedBox(height: 20.h),
                          Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildCategoryFilters(),
                          SizedBox(height: 20.h),

                          // --- Daftar Ruangan dari Firebase ---
                          FutureBuilder<List<Room>>(
                            future: _roomsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("Tidak ada ruangan tersedia."));
                              }

                              // Simpan data asli saat pertama kali dimuat
                              if (_allRooms.isEmpty) {
                                _allRooms = snapshot.data!;
                                _filteredRooms = _allRooms;
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: _filteredRooms.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final room = _filteredRooms[index];
                                  return RoomCard(room: room);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk filter kategori
  Widget _buildCategoryFilters() {
    const categories = ['All', 'Lab', 'Kelas', 'Lainnya'];
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedCategory = category;
                  _filterRooms(); // Panggil filter
                });
              }
            },
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFF0D1B4D),
            labelStyle: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: const BorderSide(
                color: Color(0xFF0D1B4D),
              ),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
