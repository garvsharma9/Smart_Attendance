// lib/screens/student/attendance_page.dart
import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  final String className;

  const AttendancePage({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$className Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                  child: Text(
                "QR Scanner Placeholder",
                style: TextStyle(color: Colors.grey),
              )),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text("Start Biometric Verification"),
              onPressed: () {
                // TODO: integrate fingerprint & face recognition
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Biometric flow not implemented")),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
