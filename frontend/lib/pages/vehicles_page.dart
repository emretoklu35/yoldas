import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);
    final user = await getCurrentUser();
    final token = await getToken();
    if (user != null && token != null) {
      final vehicles = await fetchVehicles(user['id'].toString(), token);
      setState(() {
        _vehicles = vehicles;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddVehicleDialog() async {
    final nameController = TextEditingController();
    final plateController = TextEditingController();
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final user = await getCurrentUser();
    final token = await getToken();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Araç Ekle'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Araç Adı'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              TextFormField(
                controller: plateController,
                decoration: const InputDecoration(labelText: 'Plaka'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              TextFormField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Marka'),
              ),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() != true) return;
              if (user == null || token == null) return;
              final vehicleData = {
                'name': nameController.text,
                'plate': plateController.text,
                'brand': brandController.text,
                'model': modelController.text,
                'userId': user['id'],
              };
              final success = await addVehicle(vehicleData, token);
              if (success) {
                Navigator.pop(context);
                await _loadVehicles();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Araç başarıyla eklendi'), backgroundColor: Colors.green));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Araç eklenemedi'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My vehicles'),
        leading: BackButton(),
        actions: [
          TextButton(
            onPressed: _showAddVehicleDialog,
            child: const Text(
              '+Add new',
              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My vehicles',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _vehicles.isEmpty
                      ? const Center(child: Text('Kayıtlı aracınız yok.'))
                      : Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.separated(
                            itemCount: _vehicles.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE0E0E0)),
                            itemBuilder: (context, index) {
                              final v = _vehicles[index];
                              return ListTile(
                                leading: const Icon(Icons.directions_car, color: Colors.indigo, size: 32),
                                title: Text(v['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                subtitle: Text('${v['plate'] ?? ''} • ${v['brand'] ?? ''} ${v['model'] ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                trailing: Icon(Icons.more_horiz, color: Colors.grey[600]),
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
}
