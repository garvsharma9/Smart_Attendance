// lib/screens/teacher/qr_page.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatelessWidget {
  final String qrData;
  const QRPage({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance QR")),
      body: Center(
        child: QrImageView(
          data: qrData,
          size: 250,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
