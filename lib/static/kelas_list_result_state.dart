import 'package:presensi/data/model/kelas.dart';

abstract class KelasListResultState {}

class KelasListNoneState extends KelasListResultState {}

class KelasListLoadingState extends KelasListResultState {}

class KelasListErrorState extends KelasListResultState {
  final String message;
  KelasListErrorState(this.message);
}

class KelasListResultLoadedState extends KelasListResultState {
  final List<Kelas> listKelas;
  KelasListResultLoadedState(this.listKelas);
}
