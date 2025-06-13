import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.ev_station, // şarj
      Icons.battery_full, // batarya
      Icons.local_gas_station, // benzin
      Icons.car_repair, // araba
      Icons.tire_repair, // lastik
    ];
    final iconColors = [
      Colors.green.shade700,
      Colors.blue.shade700,
      Colors.orange.shade700,
      Colors.indigo.shade700,
      Colors.grey.shade700,
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dönen ikonlar
                  ...List.generate(icons.length, (i) {
                    final angle = 2 * pi * i / icons.length;
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final rotation = _controller.value * 2 * pi;
                        final offset = Offset(
                          80 * cos(angle + rotation),
                          80 * sin(angle + rotation),
                        );
                        return Transform.translate(
                          offset: offset,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                icons[i],
                                color: iconColors[i],
                                size: 44,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  // Ortadaki logo
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(
                        'assets/icon/ic_launcher.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Yoldaş',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
                color: Color(0xFF1A3A5D),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            // Yükleme barı üzerinde soldan sağa hareket eden araba ikonu
            SizedBox(
              height: 32,
              width: 200,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 4),
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      Positioned(
                        left: value * 172, // 200 - icon width (28)
                        top: 2,
                        child: Icon(Icons.directions_car, color: Color(0xFF1A3A5D), size: 28),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Modern yükleniyor animasyonu
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 4),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFF1A3A5D),
                  borderRadius: BorderRadius.circular(8),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Yol yardımınız yolda!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 