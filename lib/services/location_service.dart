import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    try {
      // Servis kontrolü
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Konum servisi kapalı');
      }

      // İzin kontrolü
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Konum izni reddedildi');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Konum izni kalıcı olarak reddedildi');
      }

      // Konumu al
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      print('LocationService Error: $e');
      rethrow;
    }
  }

  static Future<String?> getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude,
        localeIdentifier: 'tr_TR',
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality ?? place.administrativeArea ?? ''}, ${place.street ?? place.subLocality ?? ''}';
      }
      return null;
    } catch (e) {
      print('Geocoding Error: $e');
      return null;
    }
  }
}