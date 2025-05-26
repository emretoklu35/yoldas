import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';             // ✅ HomePage import edildi
import 'pages/signup_page.dart';          // İstersen kayıt ekranını da route'a alabiliriz
import 'pages/forgot_password_page.dart'; // Aynı şekilde

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
      
      // ✅ Route yapısı tanımlandı
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}
