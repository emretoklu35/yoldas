import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpSettingsPage extends StatefulWidget {
  const IpSettingsPage({super.key});

  @override
  State<IpSettingsPage> createState() => _IpSettingsPageState();
}

class _IpSettingsPageState extends State<IpSettingsPage> {
  final _ipController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentIp();
  }

  Future<void> _loadCurrentIp() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('backend_ip');
    if (savedIp != null) {
      _ipController.text = savedIp;
    }
  }

  Future<void> _saveIp() async {
    if (_ipController.text.isEmpty) {
      setState(() => _message = 'Lütfen IP adresini girin');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // IP adresini güncelle
      AppConfig.updateBaseUrl(_ipController.text);
      
      // IP adresini kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backend_ip', _ipController.text);

      setState(() => _message = 'IP adresi başarıyla güncellendi');
    } catch (e) {
      setState(() => _message = 'Hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Ayarları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Backend IP Adresi',
                hintText: 'Örnek: 192.168.1.8',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveIp,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Kaydet'),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('başarıyla')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
} 