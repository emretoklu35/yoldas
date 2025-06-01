import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

final storage = FlutterSecureStorage();

// Base URL'i sabit olarak tanımlayalım
const String baseUrl = "http://shuttle.proxy.rlwy.net:27363/api";

Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final url = Uri.parse("$baseUrl/auth/login");
    print("Login isteği gönderiliyor: $url");
    print("Email: $email");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Sunucu yanıt vermedi. Lütfen internet bağlantınızı kontrol edin.');
      },
    );

    print("Sunucu yanıt kodu: ${response.statusCode}");
    print("Sunucu yanıtı: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      
      if (token == null) {
        print("Token bulunamadı!");
        return {
          'success': false,
          'message': 'Sunucu yanıtında token bulunamadı'
        };
      }

      await storage.write(key: 'jwt', value: token);
      print("Token başarıyla kaydedildi");
      
      return {
        'success': true,
        'message': 'Giriş başarılı',
        'token': token
      };
    } else {
      String errorMessage;
      try {
        final responseData = jsonDecode(response.body);
        errorMessage = responseData['message'] ?? 'Bilinmeyen hata';
      } catch (e) {
        errorMessage = 'Sunucu yanıtı işlenemedi';
      }

      if (response.statusCode == 401) {
        errorMessage = 'E-posta veya şifre hatalı';
      } else if (response.statusCode == 404) {
        errorMessage = 'Kullanıcı bulunamadı';
      } else if (response.statusCode == 500) {
        errorMessage = 'Sunucu hatası oluştu';
      }
      
      print("Giriş başarısız! Kodu: ${response.statusCode}, Mesaj: $errorMessage");
      return {
        'success': false,
        'message': errorMessage
      };
    }
  } on TimeoutException {
    print("Bağlantı zaman aşımına uğradı");
    return {
      'success': false,
      'message': 'Sunucu yanıt vermedi. Lütfen internet bağlantınızı kontrol edin.'
    };
  } catch (e) {
    print("Giriş sırasında bir hata oluştu: $e");
    return {
      'success': false,
      'message': 'Bağlantı hatası: ${e.toString()}'
    };
  }
}

Future<bool> signup(String email, String password, {String? name, String? phone, String? gender, String? birthday}) async {
  final url = Uri.parse("$baseUrl/auth/register");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'role': 'user',
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (gender != null) 'gender': gender,
      if (birthday != null) 'birthday': birthday,
    }),
  );

  if (response.statusCode == 201) {
    print("Kayıt başarılı: "+response.body);
    return true;
  } else {
    print("Kayıt başarısız! Kodu: "+response.statusCode.toString()+", Mesaj: "+response.body);
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
