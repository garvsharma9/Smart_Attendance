import 'package:flutter/material.dart';
import 'package:smart_attendance/services/api_service.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({Key? key}) : super(key: key);

  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createClass() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.addClass({
        "subject_name": _subjectController.text,
        "teacher_id": int.tryParse(_teacherIdController.text),
        "year": int.tryParse(_yearController.text),
        "class": _sectionController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Class created")),
      );

      // If success, return true so AdminPage can refresh
      if (response["success"] == true || response["message"] != null) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Class")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: "Subject Name"),
            ),
            TextField(
              controller: _teacherIdController,
              decoration: const InputDecoration(labelText: "Teacher ID"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: "Year"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sectionController,
              decoration:
                  const InputDecoration(labelText: "Class Section (e.g. A, B, C)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _createClass,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Create Class"),
            ),
          ],
        ),
      ),
    );
  }
}
