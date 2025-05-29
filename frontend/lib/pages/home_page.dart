import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'battery_page.dart';
import 'profile_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const String googlePlacesApiKey = 'AIzaSyDBRqqIbFoJxkNFVfnCjNUMuy1xMcwgd3g';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _address = "Konum alınıyor...";
  Position? _position;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Position? position = await LocationService.getCurrentPosition();
    if (position != null) {
      String? address = await LocationService.getAddressFromPosition(position);
      setState(() {
        _position = position;
        _address = address ?? "Konum bulunamadı";
      });
      _loadNearbyPlaces();
    } else {
      setState(() {
        _address = "Konum izni verilmedi veya servis kapalı";
      });
    }
  }

  Future<void> _loadNearbyPlaces() async {
    if (_position == null) return;
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_position!.latitude},${_position!.longitude}&radius=1500&type=gas_station&key=$googlePlacesApiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    Set<Marker> newMarkers = {
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(_position!.latitude, _position!.longitude),
        infoWindow: const InfoWindow(title: 'Mevcut Konum'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };
    if (data['results'] != null) {
      for (var place in data['results']) {
        final loc = place['geometry']['location'];
        newMarkers.add(
          Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(loc['lat'], loc['lng']),
            infoWindow: InfoWindow(title: place['name']),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  void _onBatteryTap() {
    Navigator.pushNamed(context, '/battery'); // BatteryPage için route (henüz eklenmedi)
  }

  void _onProfileTap() {
    Navigator.pushNamed(context, '/profile'); // ProfilePage için route
  }

  void _onFuelTap() {
    Navigator.pushNamed(context, '/fuel'); // FuelPage için route
  }

  void _onChargingTap() {
    Navigator.pushNamed(context, '/charging'); // ChargingPage için route
  }

  void _onTireTap() {
    Navigator.pushNamed(context, '/tire'); // TirePage için route
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 0
        ? Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Yoldaş',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.indigo, size: 32),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_address ?? '', style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                        if (_position != null)
                                          Text(
                                            'Lat: ${_position!.latitude}, Lng: ${_position!.longitude}',
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh, size: 20),
                                    onPressed: _getLocation,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.directions_car, color: Colors.indigo, size: 32),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Honda Civic', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                        Text('35BCD192 - super 95', style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_position != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_position!.latitude, _position!.longitude),
                                zoom: 15,
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              onMapCreated: (controller) => _mapController = controller,
                              markers: _markers,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          GestureDetector(
                            onTap: _onFuelTap, // Yakıt seçeneğine tıklama
                            child: _HomeIconButton(icon: Icons.local_gas_station, label: 'Yakıt'),
                          ),
                          GestureDetector(
                            onTap: _onChargingTap,
                            child: _HomeIconButton(icon: Icons.ev_station, label: 'Şarj'),
                          ),
                          GestureDetector(
                            onTap: _onBatteryTap,
                            child: _HomeIconButton(icon: Icons.battery_charging_full, label: 'Batarya'),
                          ),
                          GestureDetector(
                            onTap: _onTireTap,
                            child: _HomeIconButton(icon: Icons.car_repair, label: 'Lastikler'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Text(
                            'Duyurular',
                            style: TextStyle(fontSize: 28, color: Color(0xFF3A4668)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index == 1) {
                  _onProfileTap();
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Ana Sayfa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey,
            ),
          )
        : Container();
  }
}

class _HomeIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HomeIconButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, size: 36, color: Colors.indigo),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}