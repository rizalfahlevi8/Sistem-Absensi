import 'package:flutter/material.dart';
import 'package:presensi/provider/auth/auth_provider.dart';
import 'package:presensi/screen/admin/siswa/siswa_screen.dart';
import 'package:provider/provider.dart';

class AdminLayout extends StatefulWidget {
  final Function() onLogout;
  final Function() toFormKelas; // ✅ Tambahkan ini

  const AdminLayout({
    super.key,
    required this.onLogout,
    required this.toFormKelas, // ✅ Tambahkan ini
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      SiswaScreen(
        toFormKelas: widget.toFormKelas,
      ),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLogoutPressed(BuildContext context) async {
    final authRead = context.read<AuthProvider>();
    final result = await authRead.logout();
    if (result) widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Welcome, Admin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon:
                authWatch.isLoadingLogout
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.logout),
            onPressed:
                authWatch.isLoadingLogout
                    ? null
                    : () => _onLogoutPressed(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Siswa',
          ),
        ],
      ),
    );
  }
}
