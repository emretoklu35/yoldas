import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';

class ServiceProviderDashboard extends StatefulWidget {
  const ServiceProviderDashboard({super.key});

  @override
  State<ServiceProviderDashboard> createState() => _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  bool _isLoading = false;
  String _error = '';
  List<Map<String, dynamic>> _orders = [];
  Map<String, bool> _services = {
    'fuel': false,
    'charging': false,
    'battery': false,
    'tire': false,
  };

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _loadServices();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final orders = await getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadServices() async {
    try {
      final user = await getCurrentUser();
      if (user['services'] != null) {
        setState(() {
          _services = Map<String, bool>.from(user['services']);
        });
      }
    } catch (e) {
      print('Hizmetler yüklenirken hata: $e');
    }
  }

  Future<void> _updateServices() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await updateServices(_services);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hizmetler güncellendi')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await updateOrderStatus(orderId, status);
      await _loadOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sipariş durumu güncellendi')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      await logout();
      if (!mounted) return;
      
      // Tüm route'ları temizleyip login sayfasına yönlendir
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yapılırken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstasyon Paneli'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hizmetler',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Yakıt Hizmeti'),
                            value: _services['fuel'] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _services['fuel'] = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Şarj Hizmeti'),
                            value: _services['charging'] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _services['charging'] = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Akü Hizmeti'),
                            value: _services['battery'] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _services['battery'] = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Lastik Hizmeti'),
                            value: _services['tire'] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _services['tire'] = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _updateServices,
                            child: const Text('Hizmetleri Güncelle'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Siparişler',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (_error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_orders.isEmpty)
                    const Center(
                      child: Text('Henüz sipariş bulunmuyor'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sipariş #${order['id']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Hizmet: ${order['serviceType']}'),
                                Text('Adres: ${order['address']}'),
                                Text('Tutar: ₺${order['totalAmount']}'),
                                Text('Durum: ${order['status']}'),
                                const SizedBox(height: 16),
                                if (order['status'] == 'pending')
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _updateOrderStatus(
                                            order['id'].toString(),
                                            'accepted',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text('Kabul Et'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _updateOrderStatus(
                                            order['id'].toString(),
                                            'rejected',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text('Reddet'),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
} 