import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import 'battery_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _currentLocation = 'İzmir';
  String _currentAddress = 'Bornova 4088 sk no:119';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position? position = await LocationService.getCurrentPosition();
      if (position != null) {
        String? address = await LocationService.getAddressFromPosition(position);
        setState(() {
          _currentLocation = address?.split(',')[0] ?? 'Bilinmeyen Şehir';
          _currentAddress = address ?? 'Adres bulunamadı';
        });
      }
    } catch (e) {
      print('Konum hatası: $e');
      // Hata durumunda varsayılan değerleri koru
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _onBatteryTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BatteryPage()),
    );
  }

  void _onProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 0
        ? Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
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
                                _isLoadingLocation 
                                  ? const SizedBox(
                                      width: 32, 
                                      height: 32,
                                      child: CircularProgressIndicator(strokeWidth: 2)
                                    )
                                  : const Icon(Icons.location_on, color: Colors.indigo, size: 32),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _currentLocation, 
                                        style: TextStyle(fontWeight: FontWeight.bold), 
                                        overflow: TextOverflow.ellipsis
                                      ),
                                      Text(
                                        _currentAddress, 
                                        style: TextStyle(fontSize: 12, color: Colors.grey), 
                                        overflow: TextOverflow.ellipsis
                                      ),
                                    ],
                                  ),
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
                                Icon(Icons.directions_car, color: Colors.indigo, size: 32),
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
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _HomeIconButton(icon: Icons.local_gas_station, label: 'Yakıt'),
                        _HomeIconButton(icon: Icons.ev_station, label: 'Şarj'),
                        GestureDetector(
                          onTap: _onBatteryTap,
                          child: _HomeIconButton(icon: Icons.battery_charging_full, label: 'Batarya'),
                        ),
                        _HomeIconButton(icon: Icons.car_repair, label: 'Lastikler'),
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
                  const Spacer(),
                ],
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