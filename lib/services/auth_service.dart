import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api.dart';
import '../utils/token_storage.dart';

class AuthService {
  static Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 201) return true;

      print("Register failed: ${response.statusCode} ${response.body}");
      return false;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        await prefs.setString('refresh_token', data['refresh']);
        return true;
      }

      print("Login failed: ${response.statusCode} ${response.body}");
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> refreshTokenIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final String? refreshToken = prefs.getString('refresh_token');

    if (token == null || isTokenExpired(token)) {
      if (refreshToken == null) return null;

      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString('access_token', data['access']);
        token = data['access'];
      } else {
        print("Token refresh failed: ${response.body}");
        return null;
      }
    }
    return token;
  }
}

