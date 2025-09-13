import 'package:flutter/material.dart';

class AddClassPage extends StatefulWidget {
  final Function(String) onAdd;
  const AddClassPage({super.key, required this.onAdd});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.isNotEmpty) {
      widget.onAdd(_controller.text);
      Navigator.pop(context);
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
              controller: _controller,
              decoration: const InputDecoration(labelText: "Class Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text("Add Class")),
          ],
        ),
      ),
    );
  }
}
