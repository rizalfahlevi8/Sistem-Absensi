class Siswa {
  final String id;
  final String nama;
  final String gender;
  final String kelas;
  final String jurusan;
  final String email;

  Siswa({
    required this.id,
    required this.nama,
    required this.gender,
    required this.kelas,
    required this.jurusan,
    required this.email,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'].toString(),
      nama: json['nama'],
      gender: json['gender'],
      kelas: json['kelas'],
      jurusan: json['jurusan'],
      email: json['email'],
    );
  }
}