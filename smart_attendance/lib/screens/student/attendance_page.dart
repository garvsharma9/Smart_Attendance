import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:local_auth/local_auth.dart';

class AttendancePage extends StatefulWidget {
  final String className;
  const AttendancePage({super.key, required this.className});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _hasScanned = false;
  bool _showSuccess = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
  }

  /// Step 1: Fingerprint -> Step 2: Success Animation -> Step 3: QR Info
  Future<void> _authenticateAndProcess(String qrData) async {
    try {
      // 🔹 Step 1: Fingerprint authentication
      final bool fingerprintOk = await _localAuth.authenticate(
        localizedReason: 'Place your finger to confirm attendance',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (!fingerprintOk) {
        debugPrint('❌ Fingerprint failed');
        _hasScanned = false;
        return;
      }
      debugPrint('✅ Fingerprint success');

      // 🔹 Step 2: Show success animation
      setState(() {
        _showSuccess = true;
      });
      _animController.forward();

      await Future.delayed(const Duration(seconds: 2)); // let animation play

      // 🔹 Step 3: Process QR data
      String qrInfo;
      final uri = Uri.tryParse(qrData);
      if (uri != null && uri.queryParameters.containsKey('code')) {
        final link = uri.origin + uri.path;
        final classParam = uri.queryParameters['class'];
        final codeParam = uri.queryParameters['code'];
        qrInfo = 'Link: $link, Class: $classParam, Code: $codeParam';
      } else if (qrData.contains('|')) {
        final parts = qrData.split('|');
        qrInfo = 'Link: ${parts[0]}, Number: ${parts.length > 1 ? parts[1] : 'n/a'}';
      } else {
        qrInfo = 'Raw QR: $qrData';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance recorded ✅\n$qrInfo')),
        );
      }

      // Hide animation after a while
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _showSuccess = false;
          _animController.reset();
        });
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
      _hasScanned = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.className} Attendance')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (_hasScanned) return;
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final raw = barcodes.first.rawValue;
                      if (raw != null) {
                        _hasScanned = true;
                        _controller.stop(); // stop scanning temporarily
                        _authenticateAndProcess(raw).then((_) {
                          // Restart scanner for next student if needed
                          // _hasScanned = false;
                          // _controller.start();
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Text('Point camera at the class QR to mark attendance'),
            ],
          ),

          // ✅ Success overlay
          if (_showSuccess)
            Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Attendance Marked",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }
}
