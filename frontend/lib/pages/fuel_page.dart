import 'package:flutter/material.dart';
import 'checkout_page.dart';

class FuelPage extends StatefulWidget {
  const FuelPage({super.key});

  @override
  State<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {
  final TextEditingController _manualPriceController = TextEditingController();

  bool isFullSelected = true;
  double fullTankPrice = 1050;
  double serviceFee = 100;
  double fuelCost = 0;
  double total = 0;

  String? errorText;

  void _calculateTotal() {
    if (isFullSelected) {
      fuelCost = fullTankPrice;
      errorText = null;
    } else {
      final entered = double.tryParse(_manualPriceController.text.replaceAll(',', '.')) ?? 0;
      if (entered < 500) {
        errorText = "Minimum ₺500 girmelisiniz.";
        fuelCost = 0;
      } else {
        fuelCost = entered;
        errorText = null;
      }
    }
    setState(() {
      total = fuelCost + serviceFee;
    });
  }

  @override
  void dispose() {
    _manualPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calculateTotal(); // UI her değiştiğinde güncel toplamı göster
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yakıt Siparişi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Yakıt Türü", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          FuelOptionCard(
            title: "Kurşunsuz 95",
            subtitle: "Tam dolum veya miktarı sen belirle",
            selected: true,
          ),
          const SizedBox(height: 24),
          const Text("Dolum Seçimi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          RadioListTile<bool>(
            title: const Text("Tam Dolum (₺1050)"),
            value: true,
            groupValue: isFullSelected,
            onChanged: (val) {
              setState(() => isFullSelected = true);
            },
          ),
          RadioListTile<bool>(
            title: const Text("Elle Fiyat Girişi"),
            value: false,
            groupValue: isFullSelected,
            onChanged: (val) {
              setState(() => isFullSelected = false);
            },
          ),
          if (!isFullSelected)
            TextField(
              controller: _manualPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Yakıt Bedeli (₺)",
                errorText: errorText,
                prefixIcon: const Icon(Icons.local_gas_station),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => _calculateTotal(),
            ),
          const SizedBox(height: 24),
          const Text("Özet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SummaryRow(label: "Yakıt Bedeli", value: fuelCost),
          SummaryRow(label: "Hizmet Bedeli", value: serviceFee),
          const Divider(),
          SummaryRow(label: "Toplam", value: total, bold: true),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: (fuelCost >= 500)
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(
                          fuelCost: fuelCost,
                          serviceFee: serviceFee,
                          serviceType: 'fuel',
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Devam Et", style: TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }
}

class FuelOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;

  const FuelOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selected ? Colors.indigo.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? Colors.indigo : Colors.grey.shade300),
      ),
      child: ListTile(
        leading: const Icon(Icons.local_gas_station, color: Colors.indigo, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: selected ? const Icon(Icons.check_circle, color: Colors.indigo) : null,
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text("₺${value.toStringAsFixed(2)}", style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}