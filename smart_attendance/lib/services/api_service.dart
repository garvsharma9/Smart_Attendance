// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = 'http://10.126.146.104:5000';

  /// Add a new Class
  static Future<Map<String, dynamic>> addClass(Map<String, dynamic> classData) async {
    final url = Uri.parse('$baseUrl/add_class');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(classData));
    return _handleResponse(resp);
  }

  /// Add student
  static Future<Map<String, dynamic>> addStudent(Map<String, dynamic> studentData) async {
    final url = Uri.parse('$baseUrl/add_student');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(studentData));
    return _handleResponse(resp);
  }

  /// Enroll student into class
  static Future<Map<String, dynamic>> enrollStudent(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/enroll_student');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    return _handleResponse(resp);
  }

  /// Assign teacher (used by admin)
  static Future<Map<String, dynamic>> assignTeacher(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/assign_teacher');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    return _handleResponse(resp);
  }

  /// Add teacher (called on teacher login)
  static Future<Map<String, dynamic>> addTeacher(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/add_teacher');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    return _handleResponse(resp);
  }

  /// Get teachers list
  static Future<List<dynamic>> getTeachers() async {
    final url = Uri.parse('$baseUrl/get_teachers');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      throw Exception('Failed to load teachers: ${resp.statusCode} ${resp.body}');
    }
  }

  /// Get classes assigned to a teacher
  static Future<List<dynamic>> getTeacherClasses(String teacherId) async {
    final url = Uri.parse('$baseUrl/get_teacher_classes/$teacherId');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      throw Exception('Failed to load teacher classes: ${resp.statusCode} ${resp.body}');
    }
  }

  /// Fetch all classes
  static Future<List<dynamic>> getClasses() async {
    final url = Uri.parse('$baseUrl/get_classes');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      throw Exception('Failed to fetch classes: ${resp.statusCode} ${resp.body}');
    }
  }

  /// Verify the scanned QR/link with backend.
  /// The backend should accept JSON { "link": "<scannedString>" } and return something like { "valid": true }
  static Future<Map<String, dynamic>> verifyAttendanceLink(String link) async {
    final url = Uri.parse('$baseUrl/verify_link'); // make sure backend exposes this endpoint
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"link": link}),
    );
    return _handleResponse(resp);
  }

  /// Mark attendance (after biometric confirmed)
  /// Expects backend /mark_attendance to accept JSON:
  /// { "class_id": CLASS_ID, "student_id": STUDENT_ID, "date": "YYYY-MM-DD", "status": "Present" }
  static Future<Map<String, dynamic>> markAttendance(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/mark_attendance');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    return _handleResponse(resp);
  }

  /// Common response handler
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final body = response.body;
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        return {"success": true, "data": decoded};
      }
    } catch (e) {
      if (response.statusCode == 200) {
        return {"success": true, "message": response.body};
      } else {
        return {"success": false, "message": "HTTP ${response.statusCode}", "raw": response.body};
      }
    }
  }
}
