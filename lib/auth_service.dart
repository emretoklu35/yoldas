import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<bool> login(String email, String password) async {
  final url = Uri.parse("http://192.168.1.8:8080/api/auth/login");
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
    await storage.write(key: 'jwt', value: token); // token saklanır
    return true;
  } else {
    print("Giriş başarısız! Kodu: ${response.statusCode}, Mesaj: ${response.body}");
    return false;
  }
}
