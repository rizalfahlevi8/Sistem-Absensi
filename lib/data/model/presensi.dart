class Presensi {
  final String id;
  final String tanggal;
  final String waktu;
  final String jenis;
  final String status;
  final String latitude;
  final String longitude;
  final String namaSiswa;

  const Presensi({
    required this.id,
    required this.tanggal,
    required this.waktu,
    required this.jenis,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.namaSiswa,
  });

  factory Presensi.fromJson(Map<String, dynamic> json) {
    return Presensi(
      id: json['id'].toString(),
      tanggal: json['tanggal'] as String,
      waktu: json['waktu'] as String,
      jenis: json['jenis'] as String,
      status: json['status'] as String,
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      namaSiswa: json['nama_siswa'] as String,
    );
  }
}
