import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

Future<Map<String, dynamic>> addGasStation({
  required String placeId,
  required String name,
  required double latitude,
  required double longitude,
  required String address,
}) async {
  try {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    
    if (token == null) {
      throw Exception('Oturum açmanız gerekiyor');
    }

    final url = Uri.parse('${AppConfig.baseUrl}/gas-stations/add');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'placeId': placeId,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('İstasyon eklenemedi: ${response.body}');
    }
  } catch (e) {
    print('Hata: $e');
    throw Exception('İstasyon eklenirken bir hata oluştu: $e');
  }
}

Future<List<Map<String, dynamic>>> getNearbyGasStations() async {
  try {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    
    if (token == null) {
      throw Exception('Oturum açmanız gerekiyor');
    }

    final url = Uri.parse('${AppConfig.baseUrl}/gas-stations/nearby');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> stationsJson = json.decode(response.body);
      return stationsJson.map((json) => json as Map<String, dynamic>).toList();
    } else {
      throw Exception('İstasyonlar getirilemedi: ${response.body}');
    }
  } catch (e) {
    print('Hata: $e');
    throw Exception('İstasyonlar getirilirken bir hata oluştu: $e');
  }
} 