import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_kelas.dart';
import 'package:presensi/data/model/kelas.dart';
import 'package:presensi/static/kelas_list_result_state.dart';

class KelasListProvider extends ChangeNotifier {
  final ApiKelas _apiKelas;

  KelasListProvider(this._apiKelas);

  List<Kelas> _allKelas = [];
  List<Kelas> get allKelas => _allKelas;

  KelasListResultState _resultState = KelasListNoneState();
  KelasListResultState get resultState => _resultState;

  bool isLoadingStore = false;

  Future<void> fetchKelasList({bool reset = false}) async {
    if (reset) {
      _allKelas = [];
    }

    try {
      _resultState = KelasListLoadingState();
      notifyListeners();

      final result = await _apiKelas.index();

      if (result.error) {
        _resultState = KelasListErrorState(result.message);
        notifyListeners();
      } else {
        _allKelas.addAll(result.listKelas);
        _resultState = KelasListResultLoadedState(_allKelas);
      }
      notifyListeners();
    } on Exception catch (_) {
      _resultState = KelasListErrorState(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.',
      );
      notifyListeners();
    }
  }

  Future<dynamic> store(String nama, String jurusan) async {
    isLoadingStore = true;
    notifyListeners();
    try {
      final result = await _apiKelas.store(nama, jurusan);
      isLoadingStore = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoadingStore = false;
      notifyListeners();
      return "Something went wrong.";
    }
  }
}
