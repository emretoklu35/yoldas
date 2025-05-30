import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'personal_details_page.dart';
import 'locations_page.dart';
import 'vehicles_page.dart';
import 'orders_page.dart';
import '../auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final token = await storage.read(key: 'jwt');
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        user = data['user'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  static void _showInfoDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('Burası $title sayfası.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: BackButton(),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('Profil bilgileri getirilemedi.'))
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
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
                              CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.indigo.shade50,
                                backgroundImage: AssetImage(
                                  user != null && user!["gender"] == "Female"
                                      ? 'assets/kadin.png'
                                      : 'assets/erkek.png',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                user != null ? (user!["name"] ?? '') : '',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3A4668)),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD4AF37),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.emoji_events, color: Colors.white),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Ödüller için katıl & puan kazan!',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _ProfileMenuItem(
                                icon: Icons.person_outline,
                                text: 'Kişisel Bilgilerim',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PersonalDetailsPage()),
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.location_on_outlined,
                                text: 'Konumlarım',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LocationsPage()),
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.directions_car_outlined,
                                text: 'Araçlarım',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const VehiclesPage()),
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.receipt_long_outlined,
                                text: 'Siparişlerim',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const OrdersPage()),
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.account_balance_wallet_outlined,
                                text: 'Cüzdan',
                                onTap: () => _showInfoDialog(context, 'Cüzdan'),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.headset_mic_outlined,
                                text: 'Bize Ulaşın',
                                onTap: () => _showInfoDialog(context, 'Bize Ulaşın'),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.chat_outlined,
                                text: 'Bizimle Sohbet Et',
                                onTap: () => _showInfoDialog(context, 'Bizimle Sohbet Et'),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Çıkış'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _profileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ProfileMenuItem({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
      child: Card(
        elevation: 0,
        color: const Color(0xFFF7F7F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.grey[700]),
          title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
