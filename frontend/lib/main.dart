import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/fuel_page.dart';
import 'pages/battery_page.dart';
import 'pages/profile_page.dart';
import 'pages/charging_page.dart';
import 'pages/tire_page.dart';
import 'pages/reset_password_page.dart';
import 'pages/service_provider_dashboard.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://myqswbvbkagapzubnisp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im15cXN3YnZia2FnYXB6dWJuaXNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg4NjM0MTAsImV4cCI6MjA2NDQzOTQxMH0.d-cmNQW3CqqAhp_1tjseiVWAHDTNtXxiAOLWSB_RSaw',
  );
  
  // IP adresini otomatik tespit et
  await AppConfig.detectAndUpdateIp();
  
  runApp(const YoldasApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class YoldasApp extends StatefulWidget {
  const YoldasApp({super.key});
  @override
  State<YoldasApp> createState() => _YoldasAppState();
}

class _YoldasAppState extends State<YoldasApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial URI if app was opened from a link
    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      _handleDeepLink(uri);
    }

    // Listen for incoming links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.path == '/reset-password' && uri.queryParameters['token'] != null) {
        final token = uri.queryParameters['token']!;
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(token: token),
          ),
        );
      }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

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
      navigatorKey: navigatorKey,
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
        '/login': (context) => const LoginPage(),
        '/service-provider-dashboard': (context) => const ServiceProviderDashboard(),
      },
    );
  }
}