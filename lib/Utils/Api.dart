import 'dart:convert';
import 'package:http/http.dart' as http;

const String API = 'https://aviral.iiita.ac.in/api';

Future<http.Response?> logUser(Map<String, dynamic> obj) async {
  try {
    final response = await http.post(
      Uri.parse('$API/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obj),
    );
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response?> getSessions() async {
  try {
    final response = await http.get(Uri.parse('$API/sessions/'));
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response?> getDashboard(String jwtToken, String session) async {
  try {
    final response = await http.get(
      Uri.parse('$API/student/dashboard/'),
      headers: {
        'Authorization': jwtToken,
        'Session': session,
      },
    );
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response?> getScore(String jwtToken, String session) async {
  try {
    final response = await http.get(
      Uri.parse('$API/student/enrolled_courses/'),
      headers: {
        'Authorization': jwtToken,
        'Session': session,
      },
    );
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}
