// lib/screens/teacher/session_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionPage extends StatefulWidget {
  final String className;
  const SessionPage({super.key, required this.className});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  DateTime selectedDate = DateTime.now();

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023, 1),
      lastDate: DateTime(2100),
      builder: (context, child) {
        // Modern themed calendar
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF3B82F6), // header background
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _startAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Start Attendance Session (QR flow placeholder)"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateTime.now().year == selectedDate.year &&
        DateTime.now().month == selectedDate.month &&
        DateTime.now().day == selectedDate.day;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.className} Attendance"),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.calendar_today,
                    color: Color(0xFF3B82F6)),
                title: Text(
                  "Selected Date",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 16),
                ),
                subtitle: Text(
                  DateFormat('EEEE, dd MMM yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_calendar,
                      color: Color(0xFF3B82F6)),
                  onPressed: _pickDate,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: isToday
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text("Start Attendance Session"),
                      onPressed: _startAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 28),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.grey[100],
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Attendance history for this date will appear here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
