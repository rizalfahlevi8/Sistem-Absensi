import 'package:presensi/data/model/siswa.dart';

abstract class SiswaListResultState {}

class SiswaListNoneState extends SiswaListResultState {}

class SiswaListLoadingState extends SiswaListResultState {}

class SiswaListErrorState extends SiswaListResultState {
  final String message;
  SiswaListErrorState(this.message);
}

class SiswaListResultLoadedState extends SiswaListResultState {
  final List<Siswa> listSiswa;
  SiswaListResultLoadedState(this.listSiswa);
}
