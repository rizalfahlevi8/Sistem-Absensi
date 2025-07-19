import 'package:flutter/material.dart';
import 'package:presensi/provider/siswa/kelas_list_provider.dart';
import 'package:provider/provider.dart';

class FormKelasScreen extends StatefulWidget {
  final Function() onBack;
  const FormKelasScreen({super.key, required this.onBack});

  @override
  State<FormKelasScreen> createState() => _FormKelasScreenState();
}

class _FormKelasScreenState extends State<FormKelasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<KelasListProvider>(context, listen: false);
      final result = await provider.store(
        _namaController.text.trim(),
        _jurusanController.text.trim(),
      );

      if (result is String) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kelas berhasil ditambahkan")),
        );
        context.read<KelasListProvider>().fetchKelasList(reset: true);
        widget.onBack();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<KelasListProvider>().isLoadingStore;
    final Color darkBlue = Colors.blue[900]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text("Tambah Kelas", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            color: darkBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Form Kelas",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _namaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nama Kelas',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.class_, color: Colors.white),
                        filled: true,
                        fillColor: Colors.blue[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _jurusanController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Jurusan',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.school, color: Colors.white),
                        filled: true,
                        fillColor: Colors.blue[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _submitForm,
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Simpan",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
