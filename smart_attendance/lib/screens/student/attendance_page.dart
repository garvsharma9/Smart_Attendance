// lib/screens/student/attendance_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';


class AttendancePage extends StatelessWidget {
  final String className;

   AttendancePage({super.key, required this.className});
  final LocalAuthentication auth =  LocalAuthentication();

  Future<void> authenticateWithCustomDialogs(BuildContext context) async {
    try {
    final bool didAuthenticate = await auth.authenticate(
    localizedReason: 'Please authenticate to show account balance',
    options: const AuthenticationOptions(useErrorDialogs: false),
    );
    if(didAuthenticate)
    {ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Biometric Successfull")),
                );}
    else 
    {
      ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Biometric Unsuccessfull")),
                );
    }
    } on PlatformException catch (e) {
    if (e.code == auth_error.notAvailable) {
    print('No hardware available');
    } else if (e.code == auth_error.notEnrolled) {
    print('No biometrics enrolled');
    } else {
    print('Error: ${e.message}');
    }
    }
}

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
                authenticateWithCustomDialogs(context);
                
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
