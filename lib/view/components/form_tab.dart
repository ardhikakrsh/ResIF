import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:resif/view/components/row_button.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/models/booking.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/service/database/firestore.dart';

class FormTab extends StatefulWidget {
  final Room room;
  const FormTab({super.key, required this.room});

  @override
  State<FormTab> createState() => _FormTabState();
}

class _FormTabState extends State<FormTab> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nrpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController nama1Controller = TextEditingController();
  final TextEditingController jabatan1Controller = TextEditingController();
  final TextEditingController nama2Controller = TextEditingController();
  final TextEditingController jabatan2Controller = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController mulaiController = TextEditingController();
  final TextEditingController selesaiController = TextEditingController();
  final TextEditingController rutinitasController = TextEditingController();
  final TextEditingController berapaController = TextEditingController();
  final TextEditingController acaraController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = image);
    }
    // delete the image if the user cancels the selection
    else {
      setState(() => _pickedImage = null);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nrpController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    organizationController.dispose();
    positionController.dispose();
    nama1Controller.dispose();
    jabatan1Controller.dispose();
    nama2Controller.dispose();
    jabatan2Controller.dispose();
    tanggalController.dispose();
    mulaiController.dispose();
    selesaiController.dispose();
    rutinitasController.dispose();
    berapaController.dispose();
    acaraController.dispose();
    kategoriController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Booking User Info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
          SizedBox(height: 16.h),
          _bookingFormField(
              label: "Nama Lengkap",
              controller: nameController,
              icon: Icons.person),
          _bookingFormField(
            label: "NRP",
            controller: nrpController,
            icon: Icons.badge,
          ),
          _bookingFormField(
            label: "Email",
            controller: emailController,
            icon: Icons.email,
          ),
          _bookingFormField(
            label: "Nomor Telepon",
            controller: phoneController,
            icon: Icons.phone,
          ),
          _bookingFormField(
            label: "Departemen",
            controller: departmentController,
            icon: Icons.school,
          ),
          _bookingFormField(
            label: "Organisasi yang Diwakilkan",
            controller: organizationController,
            icon: Icons.business,
          ),
          _bookingFormField(
            label: "Jabatan",
            controller: positionController,
            icon: Icons.work,
          ),
          _bookingFormField(
            label: "Nama Penanggung Jawab Utama",
            controller: nama1Controller,
            icon: Icons.person,
          ),
          _bookingFormField(
            label: "Jabatan 1",
            controller: jabatan1Controller,
            icon: Icons.work,
          ),
          _bookingFormField(
            label: "Nama Penanggung Jawab Sekunder",
            controller: nama2Controller,
            icon: Icons.person,
          ),
          _bookingFormField(
            label: "Jabatan 2",
            controller: jabatan2Controller,
            icon: Icons.work,
          ),
          SizedBox(height: 20.h),
          Text("Booking Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
          SizedBox(height: 16.h),
          _buildDatePickerFormField(
              label: "Tanggal", controller: tanggalController),
          _buildTimePickerFormField(
              label: "Waktu Mulai", controller: mulaiController),
          _buildTimePickerFormField(
              label: "Waktu Selesai", controller: selesaiController),
          _buildDropdownFormField(
              label: "Rutinitas",
              controller: rutinitasController,
              items: [
                'Daily / Per Hari',
                'Weekly / Per Minggu',
                'Monthly / Per Bulan'
              ]),
          _bookingFormField(
            label: "Berapa Kali",
            controller: berapaController,
          ),
          SizedBox(height: 20.h),
          Text("Event Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
          SizedBox(height: 16.h),
          _bookingFormField(
            label: "Nama Acara",
            controller: acaraController,
            icon: Icons.event,
          ),
          _buildDropdownFormField(
            label: "Kategori Acara",
            controller: kategoriController,
            items: [
              'Kuliah',
              'Ujian/Evaluasi',
              'Praktikum',
              'Workshop/Seminar',
              'Rapat Organisasi',
              'Forum Warga',
              'Lomba'
            ],
          ),

          _bookingFormField(
            label: "Deskripsi Acara",
            controller: deskripsiController,
            icon: Icons.description,
          ),
          SizedBox(height: 20.h),
          Text("Upload Gambar (Poster/Foto)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _pickedImage == null
                  ? Center(
                      child: Icon(Icons.add_a_photo_rounded,
                          size: 40.sp, color: Colors.grey),
                    )
                  : Image.file(
                      File(_pickedImage!.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 20.h),
          // Tombol Submit
          RowButton(
            text1: "Batal",
            text2: "Submit",
            onPressed: onSubmitPressed,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildDatePickerFormField(
      {required String label, required TextEditingController controller}) {
    return _bookingFormField(
      label: label,
      controller: controller,
      icon: Icons.calendar_month_rounded,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    );
  }

  Widget _buildTimePickerFormField({
    required String label,
    required TextEditingController controller,
  }) {
    return _bookingFormField(
      label: label,
      controller: controller,
      icon: Icons.access_time_filled_rounded,
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          controller.text =
              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
        }
      },
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required TextEditingController controller,
    required List<String> items,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4.h),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            value: controller.text.isEmpty ? null : controller.text,
            hint: Text('Pilih $label'),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue!;
              });
            },
            validator: (value) => value == null || value.isEmpty
                ? '$label tidak boleh kosong'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _bookingFormField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    bool readOnly = false,
    void Function()? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:
                    const BorderSide(color: Color(0xFF0D1B4D), width: 2.0),
              ),
              prefixIcon: icon != null ? Icon(icon) : null,
              prefixIconColor: const Color(0xFF0D1B4D),
            ),
          ),
        ],
      ),
    );
  }

  void onSubmitPressed() async {
    FirestoreService db = FirestoreService();
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        nrpController.text.isEmpty ||
        phoneController.text.isEmpty ||
        departmentController.text.isEmpty ||
        organizationController.text.isEmpty ||
        positionController.text.isEmpty ||
        nama1Controller.text.isEmpty ||
        tanggalController.text.isEmpty ||
        mulaiController.text.isEmpty ||
        selesaiController.text.isEmpty ||
        rutinitasController.text.isEmpty ||
        berapaController.text.isEmpty ||
        acaraController.text.isEmpty ||
        kategoriController.text.isEmpty ||
        deskripsiController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please fill in all fields',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
    }

    if (_pickedImage == null) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please upload a poster image',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    final booking = BookingModel(
      roomCode: widget.room.code,
      roomName: widget.room.name,
      name: nameController.text,
      nrp: nrpController.text,
      email: emailController.text,
      phone: phoneController.text,
      department: departmentController.text,
      organization: organizationController.text,
      position: positionController.text,
      namaPJ1: nama1Controller.text,
      jabatanPJ1: jabatan1Controller.text,
      namaPJ2: nama2Controller.text,
      jabatanPJ2: jabatan2Controller.text,
      tanggal: tanggalController.text,
      mulai: mulaiController.text,
      selesai: selesaiController.text,
      rutinitas: rutinitasController.text,
      berapaKali: berapaController.text,
      acara: acaraController.text,
      kategori: kategoriController.text,
      deskripsi: deskripsiController.text,
      posterUrl: _pickedImage!.path,
      status: Status.pending, // Default status
      createdAt: DateTime.now(),
    );

    await db.addBooking(booking);
    showTopSnackbar(
      context: context,
      title: 'Success',
      message: 'Booking submitted successfully',
      contentType: ContentType.success,
      shadowColor: Colors.green.shade300,
    );
    nameController.clear();
    nrpController.clear();
    emailController.clear();
    phoneController.clear();
    departmentController.clear();
    organizationController.clear();
    positionController.clear();
    nama1Controller.clear();
    jabatan1Controller.clear();
    nama2Controller.clear();
    jabatan2Controller.clear();
    tanggalController.clear();
    mulaiController.clear();
    selesaiController.clear();
    rutinitasController.clear();
    berapaController.clear();
    acaraController.clear();
    kategoriController.clear();
    deskripsiController.clear();
    setState(() => _pickedImage = null);
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
