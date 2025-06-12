import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String infoText = '';
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => infoText = 'Lütfen e-posta adresinizi girin.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => infoText = 'Geçerli bir e-posta adresi girin.');
      return;
    }

    setState(() {
      _isLoading = true;
      infoText = '';
    });

    bool success = await requestPasswordReset(email);

    setState(() {
      _isLoading = false;
      if (success) {
        infoText = 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.';
      } else {
        infoText = 'Şifre sıfırlama isteği başarısız. Lütfen e-posta adresinizi kontrol edin veya daha sonra tekrar deneyin.';
      }
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
              const Text(
                'Şifrenizi mi unuttunuz?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
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
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : const Text('Şifreyi Sıfırla'),
                ),
              ),
              if (infoText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    infoText,
                    style: TextStyle(
                      color: infoText.contains('gönderildi') ? Colors.green : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}