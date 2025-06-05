class AppConfig {
  // Backend URL'leri
  static const String baseUrl = 'http://172.20.10.2:8080/api';
  
  // Google Maps API Key
  static const String googlePlacesApiKey = 'AIzaSyDpLfuUBn758P7VJ3SrWyLIUdWysj0-am4';
  
  // Diğer uygulama ayarları buraya eklenebilir
  static const int apiTimeout = 30000; // 30 saniye
  static const int maxRetries = 3;
} 