import 'package:flutter/material.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Locations'),
        leading: BackButton(),
        actions: [
          TextButton(
            onPressed: () {},
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
              'My Locations',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _LocationTile(
                    icon: Icons.home,
                    iconBg: Colors.white,
                    iconColor: Colors.cyan,
                    title: 'Home',
                    subtitle: '14 39B St, Jumeirah, Jumeirah 1, Dubai, United Arab Emirates, UAE',
                    trailing: Icon(Icons.more_horiz, color: Colors.grey[600]),
                  ),
                  _LocationTile(
                    icon: Icons.work_outline,
                    iconBg: Colors.white,
                    iconColor: Colors.amber,
                    title: 'Add Work',
                    subtitle: null,
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                  _LocationTile(
                    icon: Icons.star,
                    iconBg: Colors.white,
                    iconColor: Colors.amber,
                    title: 'Add custom',
                    subtitle: null,
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget trailing;
  const _LocationTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
