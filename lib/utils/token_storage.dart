import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

 bool isTokenExpired(String token) {
try {
final decoded = JwtDecoder.decode(token);
final expiry = DateTime.fromMillisecondsSinceEpoch(decoded['exp'] * 1000);
return DateTime.now().isAfter(expiry);
} catch (e) {
return true;
}
}

class TokenStorage {
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
