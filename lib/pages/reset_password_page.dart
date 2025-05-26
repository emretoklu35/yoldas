import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  final String token; // 💌 token artık dışarıdan geliyor
  ResetPasswordPage({Key? key, required this.token}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String infoText = '';

  Future<void> _submit() async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => infoText = 'Lütfen tüm alanları doldurun.');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => infoText = 'Şifreler eşleşmiyor.');
      return;
    }

    final url = Uri.parse('http://192.168.1.100:8080/api/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': widget.token,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      setState(() => infoText = 'Şifre başarıyla güncellendi 💫');
    } else {
      setState(() => infoText = 'Şifre güncellenemedi: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Şifre Belirle")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Yeni Şifre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Yeni Şifre (Tekrar)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Şifreyi Güncelle'),
            ),
            if (infoText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(infoText, style: const TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}


