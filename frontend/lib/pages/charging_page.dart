import 'package:flutter/material.dart';
import 'checkout_page.dart';

class ChargingPage extends StatefulWidget {
  const ChargingPage({super.key});

  @override
  State<ChargingPage> createState() => _ChargingPageState();
}

class _ChargingPageState extends State<ChargingPage> {
  String? selectedChargingOption;
  double chargingCost = 0;
  double serviceFee = 50; // Default service fee for charging
  double total = 0;

  final List<Map<String, dynamic>> chargingOptions = [
    {
      'name': 'Temel Şarj',
      'price': 150,
      'description': 'Acil durumlar için yeterli şarj',
      'duration': '~30 dakika',
      'imageAsset': 'assets/images/charging_basic.png', // Placeholder görsel yolu
    },
    {
      'name': 'Tam Şarj',
      'price': 300,
      'description': 'Aracın tam kapasite şarj edilmesi',
      'duration': '~60-90 dakika',
      'imageAsset': 'assets/images/charging_full.png', // Placeholder görsel yolu
    },
    {
      'name': 'Hızlı Şarj',
      'price': 500,
      'description': 'Mümkün olan en hızlı şarj hizmeti',
      'duration': '~15-30 dakika',
      'imageAsset': 'assets/images/charging_fast.png', // Placeholder görsel yolu
    },
  ];

  void _calculateTotal() {
    if (selectedChargingOption != null) {
      final selected = chargingOptions.firstWhere(
        (option) => option['name'] == selectedChargingOption,
      );
      chargingCost = (selected['price'] as num).toDouble();
      // Şarj hizmetinde sabit bir hizmet bedeli olabilir veya seçeneğe göre değişebilir.
      // Şimdilik sabit 50 TL olarak alalım.
      serviceFee = 50;
    } else {
      chargingCost = 0;
      serviceFee = 50; // Default service fee
    }
    setState(() {
      total = chargingCost + serviceFee;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedChargingOption = chargingOptions.first['name']; // Default selection
    _calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şarj Hizmeti'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Şarj Seçenekleri",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...chargingOptions.map((option) => ChargingOptionCard(
                title: option['name'] as String,
                description: option['description'] as String,
                duration: option['duration'] as String,
                price: (option['price'] as num).toDouble(),
                selected: selectedChargingOption == option['name'],
                onTap: () {
                  setState(() {
                    selectedChargingOption = option['name'] as String;
                    _calculateTotal();
                  });
                },
                imageAsset: option['imageAsset'] as String?, // Görsel yolunu iletiyoruz
              )).toList(),
          const SizedBox(height: 24),
          const Text(
            "Hizmet Detayları",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hizmet Kapsamı:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildServiceDetail("Aracın konumuna ulaşım"),
                _buildServiceDetail("Şarj ünitesinin güvenli bağlantısı"),
                _buildServiceDetail("Seçilen şarj süresince bekleme"),
                _buildServiceDetail("Şarj tamamlanınca bağlantının kesilmesi"),
                _buildServiceDetail("Ödeme sonrası işlemin sonlandırılması"),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Özet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Şarj Bedeli', chargingCost),
                _buildSummaryRow('Hizmet Bedeli', serviceFee),
                const Divider(),
                _buildSummaryRow("Toplam", total, bold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: total > 0
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(
                          fuelCost: total, // Pass total here
                          serviceFee: 0, // Service fee is already included in total
                          serviceType: 'charging',
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
            child: const Text(
              "Devam Et",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  // BatteryPage'den alınan yardımcı widget'lar
  Widget _buildServiceDetail(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            "₺${value.toStringAsFixed(2)}",
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

// BatteryOptionCard'ın şarj seçenekleri için uyarlanmış hali
class ChargingOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration; // Süre bilgisi
  final double price;
  final bool selected;
  final VoidCallback onTap;
  final String? imageAsset;

  const ChargingOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.selected,
    required this.onTap,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? Colors.teal : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageAsset != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    imageAsset!,
                    width: 40,
                    height: 40,
                    // fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.electrical_services, size: 40, color: Colors.grey), // Placeholder icon on error
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₺${price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                    const SizedBox(height: 4),
                    Text(
                      'Süre: $duration',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 