import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth_service.dart';

class Order {
  final int id;
  final String serviceType;
  final String status;
  final String address;
  final double totalAmount;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.address,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      serviceType: json['serviceType'],
      status: json['status'],
      address: json['address'],
      totalAmount: json['totalAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

Future<List<Order>> getUserOrders() async {
  try {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    
    print('Token: $token'); // Token'ı kontrol et
    
    if (token == null) {
      throw Exception('Oturum açmanız gerekiyor');
    }

    final url = Uri.parse('$baseUrl/orders');
    print('İstek URL: $url'); // URL'i kontrol et

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response Status: ${response.statusCode}'); // Status code'u kontrol et
    print('Response Body: ${response.body}'); // Response body'yi kontrol et

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Siparişler getirilemedi: ${response.body}');
    }
  } catch (e) {
    print('Hata: $e'); // Hatayı logla
    throw Exception('Siparişler getirilirken bir hata oluştu: $e');
  }
}

Future<Order> createOrder({
  required String serviceType,
  required String address,
  required double totalAmount,
  required String deliveryTime,
  required String cardNumber,
  required String cardHolder,
}) async {
  try {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    
    print('Token: $token');
    
    if (token == null) {
      throw Exception('Oturum açmanız gerekiyor');
    }

    final url = Uri.parse('$baseUrl/orders');
    print('İstek URL: $url');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'serviceType': serviceType,
        'address': address,
        'totalAmount': totalAmount,
        'deliveryTime': deliveryTime,
        'cardNumber': cardNumber,
        'cardHolder': cardHolder,
      }),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Sipariş oluşturulamadı: ${response.body}');
    }
  } catch (e) {
    print('Hata: $e');
    throw Exception('Sipariş oluşturulurken bir hata oluştu: $e');
  }
} 