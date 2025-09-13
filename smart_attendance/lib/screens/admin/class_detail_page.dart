import 'package:flutter/material.dart';

class ClassDetailPage extends StatefulWidget {
  final Map<String, dynamic> classData;
  const ClassDetailPage({super.key, required this.classData});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();

  void _addStudent() {
    if (_studentController.text.isNotEmpty) {
      setState(() {
        widget.classData['students'].add(_studentController.text);
      });
      _studentController.clear();
    }
  }

  void _assignTeacher() {
    if (_teacherController.text.isNotEmpty) {
      setState(() {
        widget.classData['teacher'] = _teacherController.text;
      });
      _teacherController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classData['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Teacher: ${widget.classData['teacher'] ?? 'Not Assigned'}"),
            TextField(
              controller: _teacherController,
              decoration: const InputDecoration(labelText: "Assign Teacher"),
              onSubmitted: (_) => _assignTeacher(),
            ),
            ElevatedButton(onPressed: _assignTeacher, child: const Text("Assign")),

            const Divider(height: 30),
            const Text("Students", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...widget.classData['students'].map<Widget>((s) => ListTile(title: Text(s))).toList(),
            TextField(
              controller: _studentController,
              decoration: const InputDecoration(labelText: "Add Student"),
              onSubmitted: (_) => _addStudent(),
            ),
            ElevatedButton(onPressed: _addStudent, child: const Text("Add Student")),
          ],
        ),
      ),
    );
  }
}
