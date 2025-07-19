import 'package:presensi/data/model/presensi.dart';

sealed class PresensiListResultState {}

class PresensiListNoneState extends PresensiListResultState {}

class PresensiListLoadingState extends PresensiListResultState {}

class PresensiListErrorState extends PresensiListResultState {
  final String error;
  PresensiListErrorState(this.error);
}

class PresensiListResultLoadedState extends PresensiListResultState {
  final List<Presensi> data;
  PresensiListResultLoadedState(this.data);
}
