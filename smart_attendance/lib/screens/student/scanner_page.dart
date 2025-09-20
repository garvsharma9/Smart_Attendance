// lib/screens/student/scanner_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_attendance/services/api_service.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _processing = false;
  int _successCount = 0;
  String? _lastLink;
  bool _scanningPaused = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// Biometric auth
  Future<bool> _authenticateBiometric() async {
    final auth = LocalAuthentication();
    try {
      final canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!canCheck) return false;
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to confirm attendance',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  /// Parse scanned string of form: teacherId|classId|randomNumber
  /// returns classId or null if parse fails
  String? _extractClassId(String scanned) {
    final parts = scanned.split('|');
    if (parts.length >= 2) {
      return parts[1]; // classId is second element
    }
    // maybe the scanned data is a full URL with query params: try to parse class_id param
    if (scanned.contains('class_id=')) {
      final regex = RegExp(r'class_id=([^&]+)');
      final m = regex.firstMatch(scanned);
      if (m != null) return Uri.decodeComponent(m.group(1)!);
    }
    return null;
  }

  /// The core flow:
  /// - call /verify_link with the scanned link repeatedly until 3 trues (or failure)
  /// - then biometric check
  /// - then call /mark_attendance to store attendance
  Future<void> _processLink(String link) async {
    if (_processing) return;
    setState(() {
      _processing = true;
      _successCount = 0;
      _lastLink = link;
      _scanningPaused = true;
    });

    // Try up to 6 attempts to collect 3 true verifications (backend might be transient)
    const int maxAttempts = 6;
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final resp = await ApiService.verifyAttendanceLink(link);
        // backend should return something like { "valid": true } or { "valid": false }
        final ok = (resp['valid'] == true) || (resp['success'] == true);
        if (ok) {
          _successCount++;
        } else {
          _successCount = 0; // reset on failure
        }
      } catch (e) {
        _successCount = 0;
      }

      if (_successCount >= 3) break;
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (_successCount >= 3) {
      // Ask for biometric
      final bioOk = await _authenticateBiometric();
      if (!bioOk) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric failed. Attendance not recorded.')));
        }
      } else {
        // Get student id from Hive
        final box = Hive.box('userBox');
        final studentId = box.get('userId') as String?;
        if (studentId == null) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student ID missing in local storage.')));
        } else {
          // parse classId from scanned link
          final classId = _extractClassId(link);
          if (classId == null) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid QR format (no class id).')));
          } else {
            final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
            try {
              final markResp = await ApiService.markAttendance({
                "class_id": classId,
                "student_id": studentId,
                "date": today,
                "status": "Present"
              });

              if ((markResp['success'] == true) || (markResp['status'] == 'success') || (markResp['message'] != null)) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance recorded ✅')));
              } else {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(markResp['message'] ?? 'Attendance API responded with failure.'))); 
              }
            } catch (e) {
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mark attendance failed: $e')));
            }
          }
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification failed — did not receive 3 successful checks.')));
      }
    }

    // reset state & resume scanning after a short delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _processing = false;
        _successCount = 0;
        _lastLink = null;
        _scanningPaused = false;
      });
    }
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    controller!.scannedDataStream.listen((scanData) async {
      final link = scanData.code;
      if (link == null) return;
      if (_processing) return;
      // prevent repeated same-link processing
      if (_lastLink != null && _lastLink == link) return;
      // pause briefly to avoid multiple events
      if (_scanningPaused) return;

      // Start the flow
      await _processLink(link);
    }, onError: (err) {
      // ignore parse errors
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Attendance QR'),
        actions: [
          if (_processing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(children: const [
                SizedBox(width: 12),
                Text('Processing...'),
              ]),
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _processing
                  ? const Text('Verifying — please wait...')
                  : const Text('Point the camera at the teacher QR'),
            ),
          ),
        ],
      ),
    );
  }
}
