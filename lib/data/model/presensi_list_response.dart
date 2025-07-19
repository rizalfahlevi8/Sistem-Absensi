import 'package:presensi/data/model/presensi.dart';

class PresensiListResponse {
   final bool error;
  final String message;
  final List<Presensi> listPresensi;

  PresensiListResponse({
    required this.error,
    required this.message,
    required this.listPresensi,
  });

  factory PresensiListResponse.fromJson(Map<String, dynamic> json) {
    return PresensiListResponse(
      error: json['error'],
      message: json['message'],
      listPresensi: (json['data'] as List)
          .map((item) => Presensi.fromJson(item))
          .toList(),
    );
  }
}