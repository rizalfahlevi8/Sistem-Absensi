import 'package:presensi/data/model/kelas.dart';

class KelasListResponse {
   final bool error;
  final String message;
  final List<Kelas> listKelas;

  KelasListResponse({
    required this.error,
    required this.message,
    required this.listKelas,
  });

  factory KelasListResponse.fromJson(Map<String, dynamic> json) {
    return KelasListResponse(
      error: json['error'],
      message: json['message'],
      listKelas: (json['data'] as List)
          .map((item) => Kelas.fromJson(item))
          .toList(),
    );
  }
}