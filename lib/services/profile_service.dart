import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import 'auth_service.dart';

class ProfileService {


  static Future<Map?> getProfile() async {
    final token = await AuthService.refreshTokenIfNeeded();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/profile/"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    print("Failed to fetch profile: ${response.statusCode} ${response.body}");
    return null;
  }

  static Future<bool> updateProfile(String username, String email, String password) async {
    final token = await AuthService.refreshTokenIfNeeded();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse("$baseUrl/profile/"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      print("Failed to update profile: ${response.statusCode} ${response.body}");
    }

    return response.statusCode == 200;
  }



  static Future<List> getSavedQuestions() async {
    final token = await AuthService.refreshTokenIfNeeded();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/saved-questions/"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to load saved questions: ${response.body}");
      return [];
    }
  }

}
