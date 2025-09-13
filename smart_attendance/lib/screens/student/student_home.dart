// lib/screens/student/student_home.dart
import 'package:flutter/material.dart';
import 'attendance_page.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  // Mock list of classes (replace with backend data later)
  final List<String> classes = const [
    "CS-A",
    "CS-B",
    "EE-A",
    "ME-C",
  ];

  void _openAttendance(BuildContext context, String className) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendancePage(className: className),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Portal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Classes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: classes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final className = classes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      title: Text(className,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _openAttendance(context, className),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
