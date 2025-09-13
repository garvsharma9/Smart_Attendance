import 'package:flutter/material.dart';
import 'add_class_page.dart';
import 'class_detail_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<Map<String, dynamic>> classes = [];

  void _addClass(String className) {
    setState(() {
      classes.add({'name': className, 'students': [], 'teacher': null});
    });
  }

  void _openClassDetail(Map<String, dynamic> classData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassDetailPage(classData: classData),
      ),
    );
  }

  void _openAddClass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddClassPage(onAdd: _addClass),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (_, index) {
          final classData = classes[index];
          return ListTile(
            title: Text(classData['name']),
            subtitle: Text(
              "Students: ${classData['students'].length} • Teacher: ${classData['teacher'] ?? 'Not Assigned'}",
            ),
            onTap: () => _openClassDetail(classData),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddClass,
        child: const Icon(Icons.add),
      ),
    );
  }
}
