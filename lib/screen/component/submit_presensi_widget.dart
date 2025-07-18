import 'package:flutter/material.dart';
import 'package:presensi/provider/home/presensi_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SubmitPresensiButton extends StatelessWidget {
  final PresensiProvider provider;
  final String buttonText;
  final bool isGettingLocation;
  final LatLng? selectedLatLng;

  const SubmitPresensiButton({
    super.key,
    required this.provider,
    required this.buttonText,
    required this.isGettingLocation,
    required this.selectedLatLng,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isGettingLocation || selectedLatLng == null)
          ? null
          : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  title: Row(
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Konfirmasi Presensi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: Text(
                    "Apakah Anda yakin ingin melakukan presensi ${provider.jenisPresensi} sekarang?",
                    style: const TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Ya, Lanjutkan"),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;

              final presensiProvider = context.read<PresensiProvider>();

              final success = await presensiProvider.createPresensi(
                selectedLatLng!.latitude.toString(),
                selectedLatLng!.longitude.toString(),
              );

              final message = presensiProvider.Message;

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? '$message' : 'Presensi gagal: $message',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isGettingLocation
                ? [Colors.grey, Colors.grey]
                : [Colors.orange[600]!, Colors.orange[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isGettingLocation
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.fingerprint, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              isGettingLocation ? "Mengambil lokasi..." : buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
