import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_auth.dart';
import 'package:presensi/routes/router_delegate.dart';

class MyApp extends StatefulWidget {
  final ApiAuth authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate(widget.authRepository);
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp.router(
      title: "FootSpot",
      routerDelegate: myRouterDelegate,
      backButtonDispatcher: RootBackButtonDispatcher(),
      debugShowCheckedModeBanner: false,
    );
  }
}
