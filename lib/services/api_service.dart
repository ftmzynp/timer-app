import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:timer/models/user_model.dart';
import 'package:timer/services/auth_storage.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        "confirmPassword": password,

      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
  String errorMessage = "Kayıt başarısız";

  try {
    final errorData = jsonDecode(response.body);

    if (errorData is Map<String, dynamic>) {
      if (errorData.containsKey("message")) {
        errorMessage = errorData["message"];
      } else if (errorData.containsKey("error")) {
        errorMessage = errorData["error"];
      } else if (errorData.containsKey("errors")) {
        errorMessage = errorData["errors"].toString();
      } else {
        errorMessage = response.body;
      }
    } else {
      errorMessage = response.body;
    }
  } catch (e) {
    errorMessage = "Status: ${response.statusCode}, Body: ${response.body}";
  }

  // 🔹 Konsola logla
  print("❌ API Hatası: $errorMessage (Status: ${response.statusCode})");

  throw Exception("Kayıt başarısız -> $errorMessage");
}


  }
  Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/auth/login');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final user = data['data']['user'];
    final token = data['data']['token'];

    // 🔹 burada token ve user’ı sakla
    await AuthStorage.saveToken(token);
    await AuthStorage.saveUser(AppUser.fromJson(user));

    return data;
  } else {
    throw Exception('Giriş başarısız: ${response.body}');
  }

}
}