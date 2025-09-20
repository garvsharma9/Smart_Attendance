// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_attendance/screens/login_page.dart';
import 'package:smart_attendance/screens/teacher/teacher_home.dart';
import 'package:smart_attendance/screens/admin/admin_page.dart';
import 'package:smart_attendance/screens/student/student_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Hive and open a box named 'userBox'
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  final box = Hive.box('userBox');
  final role = box.get('role') as String?;
  final userId = box.get('userId') as String?;

  Widget start;

  if (role == 'teacher' && userId != null && userId.isNotEmpty) {
    start = TeacherHomePage(teacherId: userId);
  } else if (role == 'admin' && userId != null && userId.isNotEmpty) {
    start = AdminPage(adminId: userId);
  } else if (role == 'student' && userId != null && userId.isNotEmpty) {
    start = StudentHomePage(studentId: userId);
  } else {
    start = const LoginPage();
  }

  runApp(SmartAttendApp(start: start));
}

class SmartAttendApp extends StatelessWidget {
  final Widget start;
  const SmartAttendApp({super.key, required this.start});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartAttend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: start,
    );
  }
}
