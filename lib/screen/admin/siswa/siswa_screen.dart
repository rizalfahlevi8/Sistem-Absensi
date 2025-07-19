import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presensi/provider/siswa/kelas_list_provider.dart';
import 'package:presensi/provider/siswa/siswa_list_provider.dart';
import 'package:presensi/data/model/siswa.dart';
import 'package:presensi/data/model/kelas.dart';
import 'package:presensi/static/kelas_list_result_state.dart';
import 'package:presensi/static/siswa_list_result.state.dart';

class SiswaScreen extends StatefulWidget {
  final Function() toFormKelas;

  const SiswaScreen({super.key, required this.toFormKelas});

  @override
  State<SiswaScreen> createState() => _SiswaScreenState();
}

class _SiswaScreenState extends State<SiswaScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final siswaProvider = Provider.of<SiswaListProvider>(
        context,
        listen: false,
      );
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        if (siswaProvider.pageItems != null) {
          siswaProvider.fetchSiswaList();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstLoad) {
      final kelasProvider = Provider.of<KelasListProvider>(
        context,
        listen: false,
      );
      final siswaProvider = Provider.of<SiswaListProvider>(
        context,
        listen: false,
      );

      kelasProvider.fetchKelasList();
      siswaProvider.fetchSiswaList(reset: true);

      _isFirstLoad = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kelasProvider = Provider.of<KelasListProvider>(context);
    final siswaProvider = Provider.of<SiswaListProvider>(context);

    return Scaffold(
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Daftar Kelas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: widget.toFormKelas,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          _buildKelasSection(kelasProvider),
          const SizedBox(height: 24),
          const Text("Daftar Siswa",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildSiswaSection(siswaProvider),
        ],
      ),
    );
  }

  Widget _buildKelasSection(KelasListProvider provider) {
    final state = provider.resultState;

    if (state is KelasListLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is KelasListErrorState) {
      return Center(child: Text(state.message));
    } else if (state is KelasListResultLoadedState) {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.allKelas.length,
          itemBuilder: (context, index) {
            final kelas = provider.allKelas[index];
            return _buildKelasCard(kelas);
          },
        ),
      );
    } else {
      return const Center(child: Text('Tidak ada data kelas.'));
    }
  }

  Widget _buildKelasCard(Kelas kelas) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(kelas.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Jurusan: ${kelas.jurusan ?? '-'}'),
        ],
      ),
    );
  }

  Widget _buildSiswaSection(SiswaListProvider provider) {
    final state = provider.resultState;

    if (state is SiswaListLoadingState && provider.allSiswa.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SiswaListErrorState && provider.allSiswa.isEmpty) {
      return Center(child: Text(state.message));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...provider.allSiswa.map(_buildSiswaCard).toList(),
          if (state is SiswaListLoadingState)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      );
    }
  }

  Widget _buildSiswaCard(Siswa siswa) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  siswa.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Gender: ${siswa.gender ?? '-'}',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            'Kelas: ${siswa.kelas ?? '-'}',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            'Jurusan: ${siswa.jurusan ?? '-'}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Email',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                siswa.email ?? '-',
                style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
