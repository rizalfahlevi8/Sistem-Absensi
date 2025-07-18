import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_auth.dart';
import 'package:presensi/data/api/api_presensi.dart';
import 'package:presensi/my_app.dart';
import 'package:presensi/provider/auth/auth_provider.dart';
import 'package:presensi/provider/home/presensi_provider.dart';
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
      ],
      child: MyApp(authRepository: authRepository),
    ),
  );
}
