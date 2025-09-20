import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your laptop's IPv4
  static String baseUrl = 'http://10.126.146.104:5000';

  /// Add a new Class with subject name + teacher + year + section
  static Future<Map<String, dynamic>> addClass(Map<String, dynamic> classData) async {
    final url = Uri.parse('$baseUrl/add_class');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(classData),
    );
    return _handleResponse(response);
  }

  /// Add a new Student
  static Future<Map<String, dynamic>> addStudent(Map<String, dynamic> studentData) async {
    final url = Uri.parse('$baseUrl/add_student');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(studentData),
    );
    return _handleResponse(response);
  }

  /// Enroll Student into a Class
  static Future<Map<String, dynamic>> enrollStudent(Map<String, dynamic> enrollmentData) async {
    final url = Uri.parse('$baseUrl/enroll_student');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(enrollmentData),
    );
    return _handleResponse(response);
  }

  /// Assign Teacher to an existing Class
  static Future<Map<String, dynamic>> assignTeacher(Map<String, dynamic> teacherData) async {
    final url = Uri.parse('$baseUrl/assign_teacher');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(teacherData),
    );
    return _handleResponse(response);
  }

  /// Fetch all Classes
  static Future<List<dynamic>> getClasses() async {
    final url = Uri.parse('$baseUrl/get_classes'); // Backend endpoint for fetching classes
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded.containsKey("classes")) {
          return decoded["classes"] as List<dynamic>;
        } else {
          throw Exception("Unexpected response format: $decoded");
        }
      } catch (e) {
        throw Exception("Failed to parse classes: $e");
      }
    } else {
      throw Exception('Failed to fetch classes: ${response.statusCode} → ${response.body}');
    }
  }

  /// Add a new Teacher
static Future<Map<String, dynamic>> addTeacher(Map<String, dynamic> teacherData) async {
  final url = Uri.parse('$baseUrl/add_teacher');
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(teacherData),
  );
  return _handleResponse(response);
}


  /// Common Response Handler
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return {"success": true, "message": "Request successful"};
        }
      } else {
        return {
          "success": false,
          "message": "Failed request: ${response.statusCode}",
          "body": response.body,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error parsing response: $e",
        "raw": response.body,
      };
    }
  }
}
