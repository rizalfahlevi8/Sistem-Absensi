import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_presensi.dart';

class PresensiProvider extends ChangeNotifier {
  final ApiPresensi apiPresensi;

  PresensiProvider({required this.apiPresensi});

  String? _jenisPresensi;
  String? get jenisPresensi => _jenisPresensi;

  String? _batasJam;
  String? get batasJam => _batasJam;

  String? _namaSiswa;
  String? get namaSiswa => _namaSiswa;

  String? _Message;
  String? get Message => _Message;

  Future<void> checkPresensi() async {
    final result = await apiPresensi.isCheck();
    _jenisPresensi = result['next'];
    _batasJam = result['batas_jam'];
    _namaSiswa = result['nama_siswa'];
    notifyListeners();
  }

  Future<bool> createPresensi(String latitude, String longitude) async {
    try {
      _Message = null;

      final result = await apiPresensi.createPresensi(latitude, longitude);

      _jenisPresensi = result['next'];
      _batasJam = result['batas_jam'];
      _Message = result['message'];

      notifyListeners(); // update state ke UI
      return true;
    } catch (e) {
      _Message = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
    }
  }
}
