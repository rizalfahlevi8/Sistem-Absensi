import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_presensi.dart';
import 'package:presensi/data/model/presensi.dart';
import 'package:presensi/static/presensi_list_result_state.dart';

class PresensiHistoryProvider extends ChangeNotifier{
  final ApiPresensi _apiPresensi;

  PresensiHistoryProvider(this._apiPresensi);

  int? pageItems = 1;
  int sizeItems = 10;

  List<Presensi> _allPresensi = [];
  List<Presensi> get allPresensi => _allPresensi;

  PresensiListResultState _resultState = PresensiListNoneState();
  PresensiListResultState get resultState => _resultState;

  Future<void> fetchPresensiList({bool reset = false}) async {
    try {
      if (reset) {
        pageItems = 1;
        _allPresensi = [];
      }

      if (pageItems == 1) {
        _resultState = PresensiListLoadingState();
        notifyListeners();
      }

      final result = await _apiPresensi.indexUser(pageItems!, sizeItems);

      if (result.error) {
        _resultState = PresensiListErrorState(result.message);
        notifyListeners();
      } else {
        _allPresensi.addAll(result.listPresensi);
        _resultState = PresensiListResultLoadedState(_allPresensi);

        if (result.listPresensi.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
        notifyListeners();
      }
    } on Exception catch (_) {
      _resultState = PresensiListErrorState(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.',
      );
      notifyListeners();
    }
  }

}