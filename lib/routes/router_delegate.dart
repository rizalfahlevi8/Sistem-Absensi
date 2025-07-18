import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_auth.dart';
import 'package:presensi/data/model/page_configuration.dart';
import 'package:presensi/provider/home/presensi_provider.dart';
import 'package:presensi/screen/auth/login_screen.dart';
import 'package:presensi/screen/home/home_screen.dart';
import 'package:presensi/screen/splash_screen.dart';
import 'package:provider/provider.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final ApiAuth authApi;

  List<Page> historyStack = [];
  bool? isLoggedIn;

  MyRouterDelegate(this.authApi) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authApi.isLoggedIn();

    if (isLoggedIn == true) {
      Future.microtask(() {
        final presensiProvider = Provider.of<PresensiProvider>(
          _navigatorKey.currentContext!,
          listen: false,
        );
        presensiProvider.checkPresensi();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {},
    );
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashPage"), child: SplashScreen()),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: Builder(
        builder:
            (context) => LoginScreen(
              onLogin: () async {
                isLoggedIn = true;
                // Jalankan checkPresensi setelah login
                final presensiProvider = Provider.of<PresensiProvider>(
                  context,
                  listen: false,
                );
                await presensiProvider.checkPresensi();
                notifyListeners();
              },
            ),
      ),
    ),
  ];

  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("HomePage"),
      child: HomeScreen(
        onLogout: () {
          isLoggedIn = false;
          notifyListeners();
        },
      ),
    ),
  ];

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
