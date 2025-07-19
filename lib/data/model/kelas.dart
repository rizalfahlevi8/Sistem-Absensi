class Kelas {
  final String id;
  final String nama;
  final String jurusan;

  Kelas({
    required this.id,
    required this.nama,
    required this.jurusan,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id'].toString(),
      nama: json['nama'],
      jurusan: json['jurusan'],
    );
  }
}