import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_siswa.dart';
import 'package:presensi/data/model/siswa.dart';
import 'package:presensi/static/siswa_list_result.state.dart';

class SiswaListProvider extends ChangeNotifier{
  final ApiSiswa _apiSiswa;

  SiswaListProvider(this._apiSiswa);

  int? pageItems = 1;
  int sizeItems = 10;

  List<Siswa> _allSiswa = [];
  List<Siswa> get allSiswa => _allSiswa;

  SiswaListResultState _resultState = SiswaListNoneState();
  SiswaListResultState get resultState => _resultState;

  Future<void> fetchSiswaList({bool reset = false}) async {
    try {
      if (reset) {
        pageItems = 1;
        _allSiswa = [];
      }

      if (pageItems == 1) {
        _resultState = SiswaListLoadingState();
        notifyListeners();
      }

      final result = await _apiSiswa.index(pageItems!, sizeItems);

      if (result.error) {
        _resultState = SiswaListErrorState(result.message);
        notifyListeners();
      } else {
        _allSiswa.addAll(result.listSiswa);
        _resultState = SiswaListResultLoadedState(_allSiswa);

        if (result.listSiswa.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
        notifyListeners();
      }
    } on Exception catch (_) {
      _resultState = SiswaListErrorState(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.',
      );
      notifyListeners();
    }
  }

}