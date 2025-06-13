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
  required String gasStationId,
}) async {
  print('Register fonksiyonu çağrıldı: email=$email, role=$role');
  print('name: $name, email: $email, password: $password, phone: $phone, role: $role, gasStationId: $gasStationId');

  final response = await http.post(
    Uri.parse('${AppConfig.baseUrl}/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'gasStationId': gasStationId,
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
  print('Logout fonksiyonu çağrıldı');
  try {
    await storage.delete(key: 'jwt');
    print('JWT token silindi');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    print('SharedPreferences verileri silindi');
  } catch (e) {
    print('Logout sırasında hata: $e');
    throw Exception('Çıkış yapılırken bir hata oluştu: $e');
  }
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

Future<bool> requestPasswordReset(String email) async {
  final url = Uri.parse('${AppConfig.baseUrl}/auth/forgot-password');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
  if (response.statusCode == 200) {
    print('Şifre sıfırlama isteği başarılı: \\${response.body}');
    return true;
  } else {
    print('Şifre sıfırlama isteği başarısız! Kodu: \\${response.statusCode}, Mesaj: \\${response.body}');
    return false;
  }
}

Future<bool> addVehicle(Map<String, dynamic> vehicleData, String jwtToken) async {
  final url = Uri.parse('${AppConfig.baseUrl}/vehicles/add');
  print('Araç ekleme URL: $url');
  print('Araç ekleme body: ${jsonEncode(vehicleData)}');


  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    },
    body: jsonEncode(vehicleData),
  );
  print('Araç ekleme status: \\${response.statusCode}');
  print('Araç ekleme body: \\${response.body}');
  return response.statusCode == 201 || response.statusCode == 200;
}

Future<List<Map<String, dynamic>>> fetchVehicles(String userId, String jwtToken) async {
  final url = Uri.parse('${AppConfig.baseUrl}/vehicles/');

  print('Araçları getirme URL: $url');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $jwtToken',
    },
  );
  print('Araçlar: ${response.body}');

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final vehiclesList = decoded['vehicles'] as List;
    return List<Map<String, dynamic>>.from(vehiclesList);
  }
  return [];
} 