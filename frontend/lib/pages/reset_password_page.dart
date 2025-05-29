import 'package:flutter/material.dart';
import 'package:yoldas/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String infoText = '';
  bool _isLoading = false;

  Future<void> _submit() async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => infoText = 'Lütfen tüm alanları doldurun.');
      return;
    }

    if (newPassword.length < 4) {
      setState(() => infoText = 'Şifre en az 4 karakter olmalı.');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => infoText = 'Şifreler eşleşmiyor.');
      return;
    }

    setState(() {
      _isLoading = true;
      infoText = '';
    });

    bool success = await resetPassword(widget.token, newPassword);

    setState(() {
      _isLoading = false;
      if (success) {
        infoText = 'Şifreniz başarıyla güncellendi. Giriş yapabilirsiniz.';
        // 2 saniye sonra login sayfasına yönlendir
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        });
      } else {
        infoText = 'Şifre güncellenemedi. Lütfen tekrar deneyin.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Şifre Belirle')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yeni Şifrenizi Belirleyin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lütfen yeni şifrenizi girin ve tekrar edin.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Yeni Şifre',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Yeni Şifre (Tekrar)',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Şifreyi Güncelle'),
              ),
            ),
            if (infoText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  infoText,
                  style: TextStyle(
                    color: infoText.contains('başarıyla') ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 