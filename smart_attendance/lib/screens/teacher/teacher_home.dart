// lib/screens/teacher/teacher_home.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_attendance/services/api_service.dart';
import 'package:smart_attendance/screens/teacher/qr_page.dart';

class TeacherHomePage extends StatefulWidget {
  final String teacherId;
  const TeacherHomePage({super.key, required this.teacherId});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  List<dynamic> assignedClasses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      final classes = await ApiService.getAssignedClasses(widget.teacherId);
      setState(() {
        assignedClasses = classes;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching classes: $e")),
      );
    }
  }

  void _logout() async {
    final box = Hive.box('userBox');
    await box.clear();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _openQR(int classId) {
    final random = Random().nextInt(1000000);
    final qrString = "${widget.teacherId}|$classId|$random";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRPage(qrData: qrString),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: assignedClasses.length,
              itemBuilder: (_, index) {
                final classData = assignedClasses[index];
                return ListTile(
                  title: Text("Class: ${classData['class_name']}"),
                  subtitle: Text("ID: ${classData['class_id']}"),
                  trailing: ElevatedButton(
                    onPressed: () => _openQR(classData['class_id']),
                    child: const Text("Show QR"),
                  ),
                );
              },
            ),
    );
  }
}
