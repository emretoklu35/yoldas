import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storage = FlutterSecureStorage();

Future<void> register({
  required String name,
  required String email,
  required String password,
  required String phone,
  required String role,
}) async {
  print('Register fonksiyonu çağrıldı: email=$email, role=$role');
  final response = await http.post(
    Uri.parse('${AppConfig.baseUrl}/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
    }),
  );

  print('API yanıt kodu: ${response.statusCode}');
  print('API yanıtı: ${response.body}');

  if (response.statusCode != 201) {
    print('Kayıt başarısız: ${response.body}');
    throw Exception(jsonDecode(response.body)['message'] ?? 'Kayıt işlemi başarısız');
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  print('Login fonksiyonu çağrıldı: email=$email');
  final response = await http.post(
    Uri.parse('${AppConfig.baseUrl}/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  print('API yanıt kodu: ${response.statusCode}');
  print('API yanıtı: ${response.body}');

  if (response.statusCode != 200) {
    print('Giriş başarısız: ${response.body}');
    final errorData = jsonDecode(response.body);
    return {
      'success': false,
      'message': errorData['message'] ?? 'Giriş başarısız'
    };
  }

  final data = jsonDecode(response.body);
  print('Giriş başarılı, token: ${data['token']}');
  await storage.write(key: 'jwt', value: data['token']);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', data['token']);
  await prefs.setString('user', jsonEncode(data['user']));
  
  return {
    'success': true,
    'user': data['user']
  };
}

Future<void> logout() async {
  await storage.delete(key: 'jwt');
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('user');
}

Future<String?> getToken() async {
  return await storage.read(key: 'jwt');
}

Future<bool> isLoggedIn() async {
  final token = await getToken();
  return token != null;
}

Future<Map<String, dynamic>> getCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userStr = prefs.getString('user');
  if (userStr == null) {
    throw Exception('Kullanıcı bulunamadı');
  }
  return jsonDecode(userStr);
} 