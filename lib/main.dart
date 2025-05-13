import 'package:flutter/material.dart';

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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorText = '';

  void _login() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username == 'yoldas' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        errorText = 'Kullanıcı adı veya şifre hatalı';
      });
    }
  }

<<<<<<< HEAD
  void _showSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _showForgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

=======
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
<<<<<<< HEAD
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Yoldaş',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome\nBack',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A4668),
                  ),
=======
              children: [
                const Icon(Icons.directions_car, size: 72, color: Colors.indigo),
                const SizedBox(height: 24),
                const Text(
                  'Yoldaş\'a Hoş Geldin!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
<<<<<<< HEAD
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: 'Email or phone number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
=======
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    border: OutlineInputBorder(),
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
<<<<<<< HEAD
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key_outlined),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _showSignUpPage,
                      child: const Text(
                        "Don't have an account?\nsign up",
                        style: TextStyle(fontSize: 13, color: Color(0xFF3A4668)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextButton(
                      onPressed: _showForgotPasswordPage,
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(fontSize: 13, color: Color(0xFF3A4668)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
=======
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
<<<<<<< HEAD
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
=======
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
                    ),
                    child: const Text('Giriş Yap'),
                  ),
                ),
                if (errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
<<<<<<< HEAD
                const SizedBox(height: 32),
=======
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
              ],
            ),
          ),
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onBatteryTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BatteryPage()),
    );
  }

  void _onProfileTap() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 0
        ? Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.indigo, size: 32),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Izmir', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                      Text('Bornova 4088 sk no:119', style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.directions_car, color: Colors.indigo, size: 32),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Honda civic', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                      Text('35BCD192 - super 95', style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _HomeIconButton(icon: Icons.local_gas_station, label: 'Fuel'),
                        _HomeIconButton(icon: Icons.ev_station, label: 'Charge'),
                        GestureDetector(
                          onTap: _onBatteryTap,
                          child: _HomeIconButton(icon: Icons.battery_charging_full, label: 'Battery'),
                        ),
                        _HomeIconButton(icon: Icons.car_repair, label: 'Tyres'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text(
                          'Announcements',
                          style: TextStyle(fontSize: 28, color: Color(0xFF3A4668)),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey,
            ),
          )
        : const ProfilePage();
  }
}

class _HomeIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HomeIconButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, size: 36, color: Colors.indigo),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorText = '';

  void _signUp() {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorText = 'Tüm alanları doldurun.';
      });
      return;
    }
    if (!email.contains('@')) {
      setState(() {
        errorText = 'Geçerli bir e-posta girin.';
      });
      return;
    }
    if (password.length < 4) {
      setState(() {
        errorText = 'Şifre en az 4 karakter olmalı.';
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        errorText = 'Şifreler eşleşmiyor.';
      });
      return;
    }
    // Kayıt başarılı
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kayıt başarılı! Giriş yapabilirsiniz.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre (Tekrar)',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Kayıt Ol'),
                  ),
                ),
                if (errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String infoText = '';

  void _resetPassword() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        infoText = 'E-posta adresinizi girin.';
      });
      return;
    }
    if (!email.contains('@')) {
      setState(() {
        infoText = 'Geçerli bir e-posta girin.';
      });
      return;
    }
    setState(() {
      infoText = 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi (simülasyon).';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifremi Unuttum')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  child: const Text('Şifreyi Sıfırla'),
                ),
              ),
              if (infoText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    infoText,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
              const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
              ),
              const SizedBox(height: 12),
              const Text(
                'zakaria durgam',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3A4668)),
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
                          'Opt-in for rewards & earn points!',
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
                text: 'My personal details',
                onTap: () => _showInfoDialog(context, 'My personal details'),
              ),
              _ProfileMenuItem(
                icon: Icons.location_on_outlined,
                text: 'My locations',
                onTap: () => _showInfoDialog(context, 'My locations'),
              ),
              _ProfileMenuItem(
                icon: Icons.directions_car_outlined,
                text: 'My vehicles',
                onTap: () => _showInfoDialog(context, 'My vehicles'),
              ),
              _ProfileMenuItem(
                icon: Icons.receipt_long_outlined,
                text: 'My orders',
                onTap: () => _showInfoDialog(context, 'My orders'),
              ),
              _ProfileMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                text: 'Wallet',
                onTap: () => _showInfoDialog(context, 'Wallet'),
              ),
              _ProfileMenuItem(
                icon: Icons.headset_mic_outlined,
                text: 'Call us',
                onTap: () => _showInfoDialog(context, 'Call us'),
              ),
              _ProfileMenuItem(
                icon: Icons.chat_outlined,
                text: 'Chat with us',
                onTap: () => _showInfoDialog(context, 'Chat with us'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  static void _showInfoDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('This is the $title page.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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

class BatteryPage extends StatelessWidget {
  const BatteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery'),
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
              title: 'Battery inspection',
              subtitle: '',
            ),
            const SizedBox(height: 16),
            _BatteryOption(
              image: Icons.battery_3_bar,
              title: 'Economy',
              subtitle: '1 year warranty',
            ),
            const SizedBox(height: 16),
            _BatteryOption(
              image: Icons.battery_full,
              title: 'Standard',
              subtitle: '1 year warranty',
            ),
          ],
=======
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoldaş - Ana Sayfa'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Giriş başarılı! Ana ekrandasın.',
          style: TextStyle(fontSize: 18),
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
        ),
      ),
    );
  }
}
<<<<<<< HEAD

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
=======
>>>>>>> d9b0776899463ce83247b5964804ad816cea05d1
