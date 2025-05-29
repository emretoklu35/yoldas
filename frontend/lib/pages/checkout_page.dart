// File: lib/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'confirmation_page.dart';

class CheckoutPage extends StatefulWidget {
  final double fuelCost;
  final double serviceFee;
  final String? serviceType;
  final Map<String, dynamic>? selectedItems;

  const CheckoutPage({
    super.key,
    required this.fuelCost,
    required this.serviceFee,
    this.serviceType,
    this.selectedItems,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? selectedSlot;
  final List<String> arrivalSlots = [
    "09:00 - 11:00",
    "11:00 - 13:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
    "17:00 - 19:00",
    "19:00 - 21:00",
    "21:00 - 23:00",
    "23:00 - 01:00",
    "01:00 - 03:00",
    "03:00 - 05:00",
    "05:00 - 07:00",
    "07:00 - 09:00",
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedSlot = arrivalSlots.first;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (_cardNumberController.text.length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kart numarası 16 hane olmalıdır')),
      );
      return false;
    }
    if (!_expiryController.text.contains(RegExp(r'^\d{2}/\d{2}$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçerli bir son kullanma tarihi girin (AA/YY)')),
      );
      return false;
    }
    if (_cvvController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CVV 3 hane olmalıdır')),
      );
      return false;
    }
    if (_cardHolderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kart sahibinin adını girin')),
      );
      return false;
    }
    return true;
  }

  void _proceedToConfirmation() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationPage(
          deliveryTime: selectedSlot ?? 'Saat belirtilmedi',
          total: widget.fuelCost + widget.serviceFee,
          address: _notesController.text.isEmpty ? 'Adres bilgisi yok' : _notesController.text,
        ),
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceType == 'battery' ? 'Akü Değişimi Ödeme' : 'Lastik/Yakıt Siparişi Ödeme'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Adres Notu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Örn. villa 5, kapı önü vs.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Geliş Zamanı", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedSlot,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.access_time),
                ),
                items: arrivalSlots.map((slot) {
                  return DropdownMenuItem<String>(
                    value: slot,
                    child: Text(slot),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSlot = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              if (widget.selectedItems != null && widget.selectedItems!.isNotEmpty) ...[
                const Text('Seçilen Ürünler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: widget.selectedItems!.entries.map((entry) {
                      final item = entry.value;
                      final double itemTotal = (item['price'] as num).toDouble() * (item['quantity'] as num).toDouble();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${entry.key} (x${item['quantity']})',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              '₺${itemTotal.toStringAsFixed(0)}', // Ensure price is visible
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const Text('Ödeme Bilgileri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Kart Numarası',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'Son Kullanma (AA/YY)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      maxLength: 5,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cardHolderController,
                decoration: InputDecoration(
                  labelText: 'Kart Sahibinin Adı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Sipariş Özeti', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      widget.serviceType == 'battery' ? 'Akü Bedeli' : 'Lastik/Yakıt Bedeli',
                      widget.fuelCost,
                    ),
                    _buildSummaryRow('Hizmet Bedeli', widget.serviceFee),
                    const Divider(),
                    _buildSummaryRow('Toplam', widget.fuelCost + widget.serviceFee, bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _proceedToConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ödemeyi Tamamla',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          Text(
            '₺${value.toStringAsFixed(0)}', // Ensure price is visible with ₺
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}