import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Base URL'i sabit olarak tanımlayalım
const String baseUrl = "http://172.20.10.2:8080/api";

Future<bool> login(String email, String password) async {
  final url = Uri.parse("$baseUrl/auth/login");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    await storage.write(key: 'jwt', value: token);
    print("Giriş başarılı, token: $token");
    return true;
  } else {
    print("Giriş başarısız! Kodu: ${response.statusCode}, Mesaj: ${response.body}");
    return false;
  }
}

Future<bool> signup(String email, String password) async {
  final url = Uri.parse("$baseUrl/auth/register");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'role': 'user',
    }),
  );

  if (response.statusCode == 201) {
    print("Kayıt başarılı: ${response.body}");
    return true;
  } else {
    print("Kayıt başarısız! Kodu: ${response.statusCode}, Mesaj: ${response.body}");
    return false;
  }
}

// Şifre sıfırlama isteği gönderme
Future<bool> requestPasswordReset(String email) async {
  final url = Uri.parse("$baseUrl/forgot-password");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
    }),
  );

  if (response.statusCode == 200) {
    print("Şifre sıfırlama isteği başarılı: ${response.body}");
    return true;
  } else {
    print("Şifre sıfırlama isteği başarısız! Kodu: ${response.statusCode}, Mesaj: ${response.body}");
    return false;
  }
}

// Yeni şifre belirleme
Future<bool> resetPassword(String token, String newPassword) async {
  final url = Uri.parse("$baseUrl/reset-password");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'token': token,
      'newPassword': newPassword,
    }),
  );

  if (response.statusCode == 200) {
    print("Şifre başarıyla sıfırlandı: ${response.body}");
    return true;
  } else {
    print("Şifre sıfırlama başarısız! Kodu: ${response.statusCode}, Mesaj: ${response.body}");
    return false;
  }
}
