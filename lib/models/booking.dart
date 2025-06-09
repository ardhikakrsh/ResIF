enum Status {
  pending,
  approved,
  rejected,
}

class BookingModel {
  final String? id;
  final String roomCode;
  final String roomName;
  final String name;
  final String nrp;
  final String email;
  final String phone;
  final String department;
  final String organization;
  final String position;
  final String namaPJ1;
  final String jabatanPJ1;
  final String namaPJ2;
  final String jabatanPJ2;
  final String tanggal;
  final String mulai;
  final String selesai;
  final String rutinitas; // dropdown
  final String berapaKali;
  final String acara;
  final String kategori; // dropdown
  final String deskripsi;
  final String posterUrl;
  final Status status;
  final DateTime createdAt;

  BookingModel({
    this.id,
    required this.roomCode, // Added
    required this.roomName,
    required this.name,
    required this.nrp,
    required this.email,
    required this.phone,
    required this.department,
    required this.organization,
    required this.position,
    required this.namaPJ1,
    required this.jabatanPJ1,
    required this.namaPJ2,
    required this.jabatanPJ2,
    required this.tanggal,
    required this.mulai,
    required this.selesai,
    required this.rutinitas,
    required this.berapaKali,
    required this.acara,
    required this.kategori,
    required this.deskripsi,
    required this.posterUrl,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomCode': roomCode, // Added
      'roomName': roomName,
      'name': name,
      'nrp': nrp,
      'email': email,
      'phone': phone,
      'department': department,
      'organization': organization,
      'position': position,
      'namaPJ1': namaPJ1,
      'jabatanPJ1': jabatanPJ1,
      'namaPJ2': namaPJ2,
      'jabatanPJ2': jabatanPJ2,
      'tanggal': tanggal,
      'mulai': mulai,
      'selesai': selesai,
      'rutinitas': rutinitas,
      'berapaKali': berapaKali,
      'acara': acara,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'imageUrl': posterUrl,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return BookingModel(
      id: id,
      roomCode: map['roomCode'] ?? '',
      roomName: map['roomName'] ?? '',
      name: map['name'] ?? '',
      nrp: map['nrp'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      department: map['department'] ?? '',
      organization: map['organization'] ?? '',
      position: map['position'] ?? '',
      namaPJ1: map['namaPJ1'] ?? '',
      jabatanPJ1: map['jabatanPJ1'] ?? '',
      namaPJ2: map['namaPJ2'] ?? '',
      jabatanPJ2: map['jabatanPJ2'] ?? '',
      tanggal: map['tanggal'] ?? '',
      mulai: map['mulai'] ?? '',
      selesai: map['selesai'] ?? '',
      rutinitas: map['rutinitas'] ?? '',
      berapaKali: map['berapaKali'] ?? '',
      acara: map['acara'] ?? '',
      kategori: map['kategori'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      posterUrl: map['posterUrl'] ?? '',
      status: Status.values.byName(map['status'] ?? 'pending'),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
