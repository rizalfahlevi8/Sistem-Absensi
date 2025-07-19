import 'package:flutter/material.dart';
import 'package:presensi/data/api/api_auth.dart';
import 'package:presensi/data/model/page_configuration.dart';
import 'package:presensi/provider/home/presensi_provider.dart';
import 'package:presensi/screen/admin/admin_layout.dart';
import 'package:presensi/screen/admin/siswa/form_kelas_screen.dart';
import 'package:presensi/screen/auth/login_screen.dart';
import 'package:presensi/screen/auth/register_screen.dart';
import 'package:presensi/screen/siswa/history/history_screen.dart';
import 'package:presensi/screen/siswa/home/home_screen.dart';
import 'package:presensi/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final ApiAuth authApi;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  String? userRole;
  bool isRegister = false;
  bool toFormKelas = false;

  MyRouterDelegate(this.authApi) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authApi.isLoggedIn();

    if (isLoggedIn == true) {
      final prefs = await SharedPreferences.getInstance();
      userRole = prefs.getString("role");
      print("User role: $userRole");

      if (userRole == "siswa") {
        Future.microtask(() {
          final presensiProvider = Provider.of<PresensiProvider>(
            _navigatorKey.currentContext!,
            listen: false,
          );
          presensiProvider.checkPresensi();
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  bool isHistory = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      if (userRole == "admin") {
        historyStack = _loggedInStackAdmin;
      } else {
        historyStack = _loggedInStackSiswa;
      }
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {
        if (page.key == const ValueKey("RegisterPage")) {
          isRegister = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
        if (page.key == const ValueKey("HistoryScreen")) {
          isHistory = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
        if (page.key == const ValueKey("FormKelasScreen")) {
          toFormKelas = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
      },
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

                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString("role");
                userRole = role;

                if (role == "siswa") {
                  final presensiProvider = Provider.of<PresensiProvider>(
                    context,
                    listen: false,
                  );
                  await presensiProvider.checkPresensi();
                }

                notifyListeners();
              },
              onRegister: () {
                isRegister = true;
                notifyListeners();
              },
            ),
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];

  List<Page> get _loggedInStackSiswa => [
    MaterialPage(
      key: const ValueKey("HomePage"),
      child: HomeScreen(
        toHistoryScreen: () {
          isHistory = true;
          notifyListeners();
        },
        onLogout: () {
          isLoggedIn = false;
          userRole = "";
          notifyListeners();
        },
      ),
    ),
    if (isHistory)
      MaterialPage(key: ValueKey("HistoryScreen"), child: HistoryScreen()),
  ];

  List<Page> get _loggedInStackAdmin => [
    MaterialPage(
      key: const ValueKey("AdminLayout"),
      child: AdminLayout(
        onLogout: () {
          isLoggedIn = false;
          userRole = "";
          notifyListeners();
        },
        toFormKelas: () {
          toFormKelas = true;
          notifyListeners();
        },
      ),
    ),
    if (toFormKelas)
      MaterialPage(
        key: ValueKey("FormKelasScreen"),
        child: FormKelasScreen(
          onBack: () {
            toFormKelas = false;
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
