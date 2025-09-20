import 'package:flutter/material.dart';
import 'package:smart_attendance/services/api_service.dart';

class ClassDetailPage extends StatefulWidget {
  final int classId;      // Class ID from DB
  final String className; // Display name of class (e.g. "DBMS - A")

  const ClassDetailPage({
    Key? key,
    required this.classId,
    required this.className,
  }) : super(key: key);

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  final TextEditingController _studentRollController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentBranchController = TextEditingController();
  final TextEditingController _studentYearController = TextEditingController();
  final TextEditingController _teacherIdController = TextEditingController();

  bool _isAddingStudent = false;
  bool _isAssigningTeacher = false;

  /// Add + Enroll a student in this class
  Future<void> _addStudentToClass() async {
    setState(() => _isAddingStudent = true);

    try {
      final studentResponse = await ApiService.addStudent({
        "roll_number": _studentRollController.text,
        "name": _studentNameController.text,
        "branch": _studentBranchController.text,
        "year": int.tryParse(_studentYearController.text),
        "class": widget.className,
      });

      final enrollResponse = await ApiService.enrollStudent({
        "student_id": _studentRollController.text,
        "class_id": widget.classId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          "${studentResponse["message"]} | ${enrollResponse["message"]}"
        )),
      );

      // Notify AdminPage to refresh
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isAddingStudent = false);
    }
  }

  /// Assign Teacher to this class
  Future<void> _assignTeacher() async {
    setState(() => _isAssigningTeacher = true);

    try {
      final response = await ApiService.assignTeacher({
        "teacher_id": int.tryParse(_teacherIdController.text),
        "class_id": widget.classId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );

      // Notify AdminPage to refresh
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isAssigningTeacher = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Class: ${widget.className}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("➕ Add Student", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _studentRollController, decoration: const InputDecoration(labelText: "Roll Number")),
            TextField(controller: _studentNameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _studentBranchController, decoration: const InputDecoration(labelText: "Branch")),
            TextField(controller: _studentYearController, decoration: const InputDecoration(labelText: "Year"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isAddingStudent ? null : _addStudentToClass,
              child: _isAddingStudent
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Add & Enroll Student"),
            ),

            const Divider(height: 40),

            const Text("👩‍🏫 Assign Teacher", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _teacherIdController, decoration: const InputDecoration(labelText: "Teacher ID"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isAssigningTeacher ? null : _assignTeacher,
              child: _isAssigningTeacher
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Assign Teacher"),
            ),
          ],
        ),
      ),
    );
  }
}
