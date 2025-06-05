import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import 'auth_service.dart';

class Order {
  final int id;
  final String serviceType;
  final String status;
  final String address;
  final String deliveryTime;
  final String cardNumber;
  final String cardHolder;
  final double totalAmount;
  final DateTime createdAt;
  final int? gasStationId;
  final Map<String, dynamic>? gasStation;

  Order({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.address,
    required this.deliveryTime,
    required this.cardNumber,
    required this.cardHolder,
    required this.totalAmount,
    required this.createdAt,
    this.gasStationId,
    this.gasStation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      serviceType: json['serviceType'],
      status: json['status'],
      address: json['address'],
      deliveryTime: json['deliveryTime'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      cardHolder: json['cardHolder'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      gasStationId: json['gasStationId'],
      gasStation: json['gasStation'],
    );
  }
}

Future<List<Order>> getUserOrders() async {
  try {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    
    print('Token: $token');
    
    if (token == null) {
      throw Exception('Oturum açmanız gerekiyor');
    }

    final url = Uri.parse('${AppConfig.baseUrl}/orders');
    print('İstek URL: $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Siparişler getirilemedi: ${response.body}');
    }
  } catch (e) {
    print('Hata: $e');
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
  int? gasStationId,
}) async {
  try {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    
    print('Token: $token');
    
    if (token == null) {
      throw Exception('Oturum açmanız gerekiyor');
    }

    final url = Uri.parse('${AppConfig.baseUrl}/orders');
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
        'gasStationId': gasStationId,
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

Future<List<Map<String, dynamic>>> getOrders() async {
  final token = await getToken();
  if (token == null) throw Exception('Oturum açmanız gerekiyor');

  final response = await http.get(
    Uri.parse('${AppConfig.baseUrl}/orders'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Siparişler getirilemedi');
  }

  final List<dynamic> data = jsonDecode(response.body);
  return data.cast<Map<String, dynamic>>();
}

Future<void> updateOrderStatus(String orderId, String status) async {
  final token = await getToken();
  if (token == null) throw Exception('Oturum açmanız gerekiyor');

  final response = await http.patch(
    Uri.parse('${AppConfig.baseUrl}/orders/$orderId/status'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'status': status,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Sipariş durumu güncellenemedi');
  }
}

Future<void> updateServices(Map<String, bool> services) async {
  final token = await getToken();
  if (token == null) throw Exception('Oturum açmanız gerekiyor');

  final response = await http.patch(
    Uri.parse('${AppConfig.baseUrl}/profile/services'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'services': services,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Hizmetler güncellenemedi');
  }
} 