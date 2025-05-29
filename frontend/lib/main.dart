import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/fuel_page.dart';
import 'pages/battery_page.dart';
import 'pages/profile_page.dart';
import 'pages/charging_page.dart';
import 'pages/tire_page.dart';

void main() {
  runApp(const YoldasApp());
}

class YoldasApp extends StatelessWidget {
  const YoldasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoldaş',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/fuel': (context) => const FuelPage(),
        '/battery': (context) => const BatteryPage(),
        '/profile': (context) => const ProfilePage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/charging': (context) => const ChargingPage(),
        '/tire': (context) => const TirePage(),
      },
    );
  }
}