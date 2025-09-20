import 'package:flutter/material.dart';
import 'package:smart_attendance/services/api_service.dart';
import 'add_class_page.dart';
import 'class_detail_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> classes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedClasses = await ApiService.getClasses();
      setState(() {
        classes = fetchedClasses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch classes: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openClassDetail(dynamic classData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassDetailPage(
          classId: classData["id"],
          className: "${classData["subject_name"]} - ${classData["class"]}",
        ),
      ),
    );
  }

  void _openAddClass() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddClassPage()),
    );

    if (result == true) {
      _fetchClasses(); // refresh list after class is added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : classes.isEmpty
              ? const Center(child: Text("No classes available"))
              : ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (_, index) {
                    final classData = classes[index];
                    return ListTile(
                      title: Text("${classData["subject_name"]} (${classData["class"]})"),
                      subtitle: Text(
                        "Year: ${classData["year"] ?? "-"} • Teacher: ${classData["teacher_id"] ?? "Not Assigned"}",
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
