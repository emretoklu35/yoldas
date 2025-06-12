import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AppConfig {
  // Backend URL'leri
  static String baseUrl = 'http://192.168.1.8:8080/api';
  
  // Google Maps API Key
  static const String googlePlacesApiKey = 'AIzaSyDpLfuUBn758P7VJ3SrWyLIUdWysj0-am4';
  
  // Diğer uygulama ayarları buraya eklenebilir
  static const int apiTimeout = 30000; // 30 saniye
  static const int maxRetries = 3;

  // IP adresini otomatik tespit et ve kaydet
  static Future<String> detectAndUpdateIp() async {
    try {
      if (Platform.isAndroid) {
        // Android emülatör için özel IP
        baseUrl = 'http://10.0.2.2:8080/api';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('backend_ip', '10.0.2.2');
        print('Android emülatör: 10.0.2.2');
        return '10.0.2.2';
      } else {
        final info = NetworkInfo();
        final wifiIP = await info.getWifiIP();
        if (wifiIP != null) {
          baseUrl = 'http://$wifiIP:8080/api';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('backend_ip', wifiIP);
          print('Otomatik IP tespiti: $wifiIP');
          return wifiIP;
        }
        // Eğer IP tespit edilemezse, kaydedilmiş son IP'yi kullan
        final prefs = await SharedPreferences.getInstance();
        final savedIp = prefs.getString('backend_ip');
        if (savedIp != null) {
          baseUrl = 'http://$savedIp:8080/api';
          print('Kaydedilmiş IP kullanılıyor: $savedIp');
          return savedIp;
        }
        throw Exception('IP adresi tespit edilemedi ve kaydedilmiş IP bulunamadı');
      }
    } catch (e) {
      print('IP tespiti hatası: $e');
      rethrow;
    }
  }

  // IP adresini manuel güncelleme metodu
  static Future<void> updateBaseUrl(String newIp) async {
    baseUrl = 'http://$newIp:8080/api';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backend_ip', newIp);
  }
} 