import 'package:flutter/material.dart';
import 'package:presensi/data/model/kelas.dart';
import 'package:presensi/provider/auth/auth_provider.dart';
import 'package:presensi/provider/siswa/kelas_list_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();
  String? selectedGender;
  String? selectedKelasId;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KelasListProvider>().fetchKelasList();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoadingRegister;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  "Buat Akun Baru",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Isi data di bawah untuk mendaftar",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

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

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kata sandi tidak boleh kosong.";
                    }
                    if (value.length < 8) {
                      return "Kata sandi minimal 8 karakter.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: "Jenis Kelamin",
                    prefixIcon: const Icon(Icons.wc),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'lk', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'pr', child: Text('Perempuan')),
                  ],
                  onChanged: (value) => setState(() => selectedGender = value),
                  validator:
                      (value) => value == null ? "Pilih jenis kelamin." : null,
                ),
                const SizedBox(height: 16),

                Consumer<KelasListProvider>(
                  builder: (context, kelasProvider, child) {
                    return DropdownButtonFormField<String>(
                      value: selectedKelasId,
                      decoration: InputDecoration(
                        labelText: "Kelas",
                        prefixIcon: const Icon(Icons.class_),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          kelasProvider.allKelas.map((Kelas kelas) {
                            return DropdownMenuItem(
                              value: kelas.id.toString(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(kelas.nama),
                                  SizedBox(width: 8), // Jarak antar teks
                                  Text(
                                    kelas.jurusan,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      onChanged:
                          (value) => setState(() => selectedKelasId = value),
                      validator:
                          (value) => value == null ? "Pilih kelas." : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

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
                                .register(
                                  namaController.text,
                                  selectedGender!,
                                  selectedKelasId!,
                                  emailController.text,
                                  passwordController.text,
                                );
                            if (result == true) {
                              widget.onLogin();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User berhasil ditambahkan"),
                                ),
                              );
                            } else if (result is String) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            }
                          }
                        },

                        child: Text("Daftar", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => widget.onLogin(),
                  child: Text(
                    "Sudah punya akun? Masuk",
                    style: TextStyle(color: Colors.green),
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
