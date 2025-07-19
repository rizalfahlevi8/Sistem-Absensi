import 'package:presensi/data/model/siswa.dart';

class SiswaListResponse {
   final bool error;
  final String message;
  final List<Siswa> listSiswa;

  SiswaListResponse({
    required this.error,
    required this.message,
    required this.listSiswa,
  });

  factory SiswaListResponse.fromJson(Map<String, dynamic> json) {
    return SiswaListResponse(
      error: json['error'],
      message: json['message'],
      listSiswa: (json['data'] as List)
          .map((item) => Siswa.fromJson(item))
          .toList(),
    );
  }
}