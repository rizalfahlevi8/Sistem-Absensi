import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_auth.dart';
import 'package:presensi/data/api/api_kelas.dart';
import 'package:presensi/data/api/api_presensi.dart';
import 'package:presensi/data/api/api_siswa.dart';
import 'package:presensi/my_app.dart';
import 'package:presensi/provider/auth/auth_provider.dart';
import 'package:presensi/provider/history/presensi_history_provider.dart';
import 'package:presensi/provider/home/presensi_provider.dart';
import 'package:presensi/provider/siswa/kelas_list_provider.dart';
import 'package:presensi/provider/siswa/siswa_list_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final authRepository = ApiAuth();
  final authProvider = AuthProvider(authRepository);

  runApp( 
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiAuth()),
        Provider(create: (context) => ApiPresensi()),
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(create: (context) => PresensiProvider(apiPresensi: ApiPresensi())),
        ChangeNotifierProvider(create: (context) => PresensiHistoryProvider(ApiPresensi())),
        ChangeNotifierProvider(create: (context) => KelasListProvider(ApiKelas())),
        ChangeNotifierProvider(create: (context) => SiswaListProvider(ApiSiswa())),
      ],
      child: MyApp(authRepository: authRepository),
    ),
  );
}
