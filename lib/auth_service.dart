import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// LOGIN
Future<bool> login(String email, String password) async {
  //final url = Uri.parse("http://192.168.1.8:8080/api/auth/login");
  final url = Uri.parse("http://10.0.2.2:8080/api/auth/login");

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

// SIGNUP (KAYIT)
Future<bool> signup(String email, String password) async {
  final url = Uri.parse("http://192.168.1.8:8080/api/auth/register");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'role': 'user', // ✨ Bu satır eksikti, artık her şey tamam
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



