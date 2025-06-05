import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Google Haritalar'ı açmak için eklendi
import '../services/location_service.dart';
import '../widgets/vehicle_selector.dart'; // Vehicle and VehicleSelector
import '../services/gas_station_service.dart';
import '../config/app_config.dart';

// Google Places API Key'i config'den al
const String googlePlacesApiKey = AppConfig.googlePlacesApiKey;

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

  // Araç seçici için state'ler
  late List<Vehicle> _vehicles;
  late Vehicle _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _initializeVehicles(); // Araçları initialize et
    _getLocation();
  }

  void _initializeVehicles() {
    // Örnek araçlar (Bu verileri bir API'den veya yerel depodan alabilirsiniz)
    _vehicles = [
      Vehicle(
        name: 'Honda Civic',
        plate: '35BCD192',
        icon: Icons.directions_car_filled, // Dolu ikon daha belirgin olabilir
        // logoAsset: 'assets/logos/honda_logo.png', // Eğer logo varsa
      ),
      Vehicle(
        name: 'Toyota Corolla',
        plate: '34XYZ789',
        icon: Icons.local_taxi,
      ),
      Vehicle(
        name: 'Ford Focus',
        plate: '06ABC123',
        icon: Icons.drive_eta_rounded,
      ),
    ];
    // Başlangıçta ilk aracı seçili yap
    // Eğer _vehicles listesi boş olabilecekse, burada kontrol ekleyin
    if (_vehicles.isNotEmpty) {
      _selectedVehicle = _vehicles.first;
    } else {
      // Boş liste durumu için varsayılan bir araç veya hata yönetimi
      _selectedVehicle = Vehicle(
          name: "Araç Yok",
          plate: "-",
          icon: Icons.error_outline);
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _address = "Konum alınıyor..."; // Kullanıcıya geri bildirim
    });
    Position? position = await LocationService.getCurrentPosition();
    if (mounted) { // Widget hala ağaçtaysa devam et
      if (position != null) {
        String? address = await LocationService.getAddressFromPosition(position);
        setState(() {
          _position = position;
          _address = address ?? "Konum adresi bulunamadı";
        });
        _loadNearbyPlaces();
        _updateMapLocation();
      } else {
        setState(() {
          _address = "Konum izni verilmedi veya servis kapalı.";
        });
      }
    }
  }

  void _updateMapLocation() {
    if (_position != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_position!.latitude, _position!.longitude),
          15, // İstediğiniz zoom seviyesi
        ),
      );
    }
  }

  Future<void> _handleMarkerTap(Marker marker) async {
    if (marker.markerId.value == 'currentLocation') return;

    try {
      print('Marker tıklandı: ${marker.markerId.value}');
      
      // Google Places API'den detaylı bilgi al
      final detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=${marker.markerId.value}&fields=name,formatted_address&key=$googlePlacesApiKey';
      print('API isteği yapılıyor: $detailsUrl');
      
      final response = await http.get(Uri.parse(detailsUrl));
      print('API yanıtı: ${response.statusCode} - ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final placeDetails = data['result'];
          print('Yer detayları: $placeDetails');
          
          // Benzin istasyonunu veritabanına ekle
          try {
            final result = await addGasStation(
              placeId: marker.markerId.value,
              name: placeDetails['name'] ?? 'İsimsiz İstasyon',
              latitude: marker.position.latitude,
              longitude: marker.position.longitude,
              address: placeDetails['formatted_address'] ?? '',
            );
            print('İstasyon ekleme sonucu: $result');

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Benzin istasyonu başarıyla kaydedildi'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            print('İstasyon ekleme hatası: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('İstasyon eklenirken hata oluştu: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          print('API yanıtında hata: ${data['status']}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Yer bilgileri alınamadı: ${data['status']}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        print('API isteği başarısız: ${response.statusCode}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yer bilgileri alınamadı: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Genel hata: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bir hata oluştu: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadNearbyPlaces() async {
    if (_position == null) return;
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_position!.latitude},${_position!.longitude}&radius=1500&type=gas_station&key=$googlePlacesApiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (mounted) {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          Set<Marker> newMarkers = {
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(_position!.latitude, _position!.longitude),
              infoWindow: const InfoWindow(title: 'Mevcut Konumunuz'),
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
                  onTap: () => _handleMarkerTap(Marker(
                    markerId: MarkerId(place['place_id']),
                    position: LatLng(loc['lat'], loc['lng']),
                  )),
                ),
              );
            }
          }
          setState(() {
            _markers = newMarkers;
          });
        }
      }
    } catch (e) {
      print('Error loading nearby places: $e');
    }
  }

  Future<void> _openLocationInMaps() async {
    if (_position != null) {
      final lat = _position!.latitude;
      final lng = _position!.longitude;
      // Google Haritalar'da konumu göstermek için URL
      final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      // Alternatif olarak belirli bir adresi de aratabilirsiniz:
      // final query = Uri.encodeComponent(_address ?? '$lat,$lng');
      // final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Haritalar açılamadı. Lütfen yüklü olduğundan emin olun.')),
          );
        }
        print('Could not launch $googleMapsUrl');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konum bilgisi henüz alınamadı.')),
        );
      }
    }
  }

  void _onBatteryTap() => Navigator.pushNamed(context, '/battery');
  void _onProfileTap() => Navigator.pushNamed(context, '/profile');
  void _onFuelTap() => Navigator.pushNamed(context, '/fuel');
  void _onChargingTap() => Navigator.pushNamed(context, '/charging');
  void _onTireTap() => Navigator.pushNamed(context, '/tire');

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Yoldaş',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo, // Ana renk
                    letterSpacing: 1.5, // Harf aralığı
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Hizalamayı iyileştir
                  children: [
                    // Konum Bilgisi Alanı
                    Expanded(
                      child: GestureDetector(
                        onTap: _openLocationInMaps,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18), // VehicleSelector ile uyumlu
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05), // Hafif gölge
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.indigo, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
                                  children: [
                                    Text(
                                      _address ?? 'Konum bekleniyor...',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (_position != null)
                                      Text(
                                        'Lat: ${_position!.latitude.toStringAsFixed(3)}, Lng: ${_position!.longitude.toStringAsFixed(3)}',
                                        style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, size: 22, color: Colors.grey),
                                onPressed: _getLocation,
                                tooltip: 'Konumu Yenile',
                                padding: EdgeInsets.zero, // Ekstra paddingi kaldır
                                constraints: const BoxConstraints(), // Ekstra paddingi kaldır
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Araç Seçici Widget'ı
                    Expanded(
                      child: _vehicles.isNotEmpty
                          ? VehicleSelector(
                              vehicles: _vehicles,
                              initialVehicle: _selectedVehicle,
                              onChanged: (vehicle) {
                                if (mounted) {
                                  setState(() {
                                    _selectedVehicle = vehicle;
                                  });
                                }
                              },
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red, size: 32),
                                  const SizedBox(width: 10),
                                  Text("Araç Yok", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Harita Alanı
              if (_position != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 250, // Harita yüksekliği
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Yuvarlak köşeler
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_position!.latitude, _position!.longitude),
                          zoom: 14.5,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onMapCreated: (controller) {
                           if(mounted){
                            setState(() { // setState içinde _mapController ataması
                              _mapController = controller;
                            });
                           }
                        },
                        markers: _markers,
                        zoomControlsEnabled: false, // Yakınlaştırma butonlarını kaldır
                        mapToolbarEnabled: false, // Harita araç çubuğunu kaldır
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
                  child: Center(
                    child: _address == "Konum alınıyor..."
                        ? const CircularProgressIndicator()
                        : Text(
                            _address ?? "Harita yüklenemedi. Konum bilgisi gerekiyor.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                  ),
                ),
              const SizedBox(height: 24),
              // Butonlar Alanı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 3, // Yatayda 3 buton
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12, // Dikey boşluk
                  crossAxisSpacing: 12, // Yatay boşluk
                  childAspectRatio: 1.05, // Butonların en/boy oranı
                  children: [
                    _HomeIconButton(icon: Icons.local_gas_station, label: 'Yakıt Siparişi', onTap: _onFuelTap),
                    _HomeIconButton(icon: Icons.ev_station, label: 'Şarj Siparişi', onTap: _onChargingTap),
                    _HomeIconButton(icon: Icons.battery_charging_full, label: 'Akü Siparişi', onTap: _onBatteryTap),
                    _HomeIconButton(icon: Icons.tire_repair_rounded, label: 'Lastik Siparişi', onTap: _onTireTap),
                    // Diğer butonlar buraya eklenebilir, örneğin:
                    // _HomeIconButton(icon: Icons.car_crash_outlined, label: 'Servis', onTap: () {}),
                    // _HomeIconButton(icon: Icons.document_scanner_outlined, label: 'Belgeler', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Duyurular Alanı
              Padding(
                padding: const EdgeInsets.fromLTRB(16,0,16,24), // Alt boşluk eklendi
                child: Container(
                  width: double.infinity,
                  height: 100, // Yükseklik ayarlandı
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                     boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                  ),
                  child: const Center(
                    child: Text(
                      'Duyurular Alanı', // Metin güncellendi
                      style: TextStyle(fontSize: 20, color: Color(0xFF3A4668), fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) { // Profil sekmesi
            _onProfileTap(); // Doğrudan profil sayfasına yönlendir
          } else { // Ana Sayfa sekmesi
            if (_selectedIndex != index) {
              if (mounted) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 10.0, // Belirgin gölge
        type: BottomNavigationBarType.fixed, // Etiketler her zaman görünür
      ),
    );

    // _selectedIndex 0 ise ana içeriği, değilse (şu an için) boş bir Container döndürür.
    // Profil sayfası BottomNav üzerinden yönetilecekse, _selectedIndex == 1 durumunda ProfilePage() döndürülmeli.
    return _selectedIndex == 0 ? mainContent : Container(); // Profil sayfası Navigator ile açıldığı için
  }
}

class _HomeIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // Tıklama fonksiyonu eklendi

  const _HomeIconButton({
    required this.icon,
    required this.label,
    this.onTap, // onTap constructor'a eklendi
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Tıklanabilirlik için GestureDetector
      onTap: onTap,
      child: Container( // Dış Container (isteğe bağlı, gölge vb. için)
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18), // Daha yuvarlak
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // İçeriği dikeyde ortala
          children: [
            Icon(icon, size: 38, color: Colors.indigo), // İkon
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}