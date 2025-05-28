import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatelessWidget {
  final double lat;
  final double lng;

  const MapPickerPage({required this.lat, required this.lng, super.key});

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(title: const Text("Haritada Gör")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('current'),
            position: initialPosition,
          ),
        },
      ),
    );
  }
}
