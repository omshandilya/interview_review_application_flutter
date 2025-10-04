import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import '../constants/api.dart';
import 'auth_service.dart';



class QuestionService {
  static Future<List> getQuestions() async {
    final token = await AuthService.refreshTokenIfNeeded();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/questions/"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to fetch questions: ${response.body}");
      return [];
    }
  }



  static Future<List> generateQuestions(String topic) async {
    final token = await AuthService.refreshTokenIfNeeded();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/generate-questions/$topic/"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print("Failed to generate questions: ${response.body}");
      return [];
    }
  }


  static Future<bool> saveQuestion(int questionId) async {
    final token = await AuthService.getAccessToken();
    final response = await http.post(
      Uri.parse("$baseUrl/save-question/"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"question": questionId}),
    );

    print("Save question status: ${response.statusCode}");
    print("Save question body: ${response.body}");

    return response.statusCode == 201;
  }



  static Future<Map<String, dynamic>> submitAnswer(int qid, File file) async {
    final token = await AuthService.refreshTokenIfNeeded();
    if (token == null) return {"error": "No token"};

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/submit-answer/"),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['question_id'] = qid.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio_file',
        file.path,
        contentType: MediaType('audio', 'mpeg'),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print("Submit failed: ${response.statusCode} ${response.body}");
      return {"error": "Failed to submit"};
    }
  }
}

