import 'package:flutter/material.dart';

class BatteryPage extends StatelessWidget {
  const BatteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batarya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BatteryOption(
              image: Icons.electric_moped,
              title: 'Batarya Kontrolü',
              subtitle: '',
            ),
            const SizedBox(height: 16),
            _BatteryOption(
              image: Icons.battery_3_bar,
              title: 'Ekonomi',
              subtitle: '1 yıl garanti',
            ),
            const SizedBox(height: 16),
            _BatteryOption(
              image: Icons.battery_full,
              title: 'Standart',
              subtitle: '1 yıl garanti',
            ),
          ],
        ),
      ),
    );
  }
}

class _BatteryOption extends StatelessWidget {
  final IconData image;
  final String title;
  final String subtitle;
  const _BatteryOption({required this.image, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(image, size: 40, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        onTap: () {},
      ),
    );
  }
}
