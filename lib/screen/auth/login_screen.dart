import 'package:flutter/material.dart';
import 'package:presensi/provider/auth/auth_provider.dart';
import 'package:presensi/provider/history/presensi_history_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _obscurePassword = true; // ✅ Tambahkan state untuk lihat password

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoadingLogin;

    return Scaffold(
      appBar: AppBar(
        title: Text("Presensi", style: Theme.of(context).textTheme.labelSmall),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                Text(
                  "Selamat Datang",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Silakan masukan akun Anda untuk masuk",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Email field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong.";
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return "Masukkan email yang valid.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field dengan tombol lihat password
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kata sandi tidak boleh kosong.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Tombol login
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final result = await context
                                .read<AuthProvider>()
                                .login(
                                  emailController.text,
                                  passwordController.text,
                                );
                            if (result == true) {
                              widget.onLogin();
                              context
                                  .read<PresensiHistoryProvider>()
                                  .fetchPresensiList(reset: true);
                            } else if (result is String) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            }
                          }
                        },
                        child: Text("Masuk", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => widget.onRegister(),
                  child: Text(
                    "Belum punya akun? Daftar",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
