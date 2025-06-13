import 'package:flutter/material.dart';
import 'checkout_page.dart';
import 'create_order_page.dart';
import '../services/gas_station_service.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  String? selectedBattery;
  double batteryCost = 0;
  double serviceFee = 150;
  double total = 0;
  String? _selectedGasStationId;
  List<Map<String, dynamic>> _nearbyStations = [];
  bool _isLoadingStations = false;
  String _stationError = '';

  final List<Map<String, dynamic>> batteryOptions = [
    {
      'name': 'Akü Kontrolü',
      'price': 300,
      'description': 'Sadece akü durumu kontrolü',
      'warranty': '-',
      'imageAsset': 'assets/images/battery_inspection.png',
    },
    {
      'name': '60 Ah Akü',
      'price': 2500,
      'description': 'Küçük araçlar için uygun',
      'warranty': '24 Ay Garanti',
      'imageAsset': 'assets/images/battery_60ah.png',
    },
    {
      'name': '70 Ah Akü',
      'price': 2800,
      'description': 'Orta boy araçlar için ideal',
      'warranty': '24 Ay Garanti',
      'imageAsset': 'assets/images/battery_70ah.png',
    },
    {
      'name': '80 Ah Akü',
      'price': 3200,
      'description': 'Büyük araçlar için uygun',
      'warranty': '24 Ay Garanti',
      'imageAsset': 'assets/images/battery_80ah.png',
    },
    {
      'name': '90 Ah Akü',
      'price': 3800,
      'description': 'SUV ve ticari araçlar için',
      'warranty': '24 Ay Garanti',
      'imageAsset': 'assets/images/battery_90ah.png',
    },
  ];

  void _calculateTotal() {
    if (selectedBattery != null) {
      final selected = batteryOptions.firstWhere(
        (battery) => battery['name'] == selectedBattery,
      );
      batteryCost = (selected['price'] as num).toDouble();
      serviceFee = (selected['name'] == 'Akü Kontrolü') ? 0 : 150;
    } else {
      batteryCost = 0;
      serviceFee = 150;
    }
    setState(() {
      total = batteryCost + serviceFee;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedBattery = batteryOptions.first['name'];
    _calculateTotal();
    _loadNearbyStations();
  }

  Future<void> _loadNearbyStations() async {
    setState(() {
      _isLoadingStations = true;
      _stationError = '';
    });

    try {
      final stations = await getNearbyGasStations();
      setState(() {
        _nearbyStations = stations;
        _isLoadingStations = false;
      });
    } catch (e) {
      setState(() {
        _stationError = 'Yakındaki istasyonlar yüklenirken hata oluştu: $e';
        _isLoadingStations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akü Değişimi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Akü Seçimi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...batteryOptions.map((battery) => BatteryOptionCard(
                title: battery['name'] as String,
                description: battery['description'] as String,
                warranty: battery['warranty'] as String,
                price: (battery['price'] as num).toDouble(),
                selected: selectedBattery == battery['name'],
                onTap: () {
                  setState(() {
                    selectedBattery = battery['name'] as String;
                    _calculateTotal();
                  });
                },
                imageAsset: battery['imageAsset'] as String?,
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
                _buildServiceDetail("Eski akünün sökülmesi"),
                _buildServiceDetail("Yeni akünün takılması"),
                _buildServiceDetail("Akü bağlantılarının kontrolü"),
                _buildServiceDetail("Şarj sisteminin test edilmesi"),
                _buildServiceDetail("Eski akünün geri dönüşüme gönderilmesi"),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Akü İstasyonu Seçimi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_isLoadingStations)
            const Center(child: CircularProgressIndicator())
          else if (_stationError.isNotEmpty)
            Center(
              child: Text(
                _stationError,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (_nearbyStations.isEmpty)
            const Center(
              child: Text(
                'Yakınızda istasyon bulunamadı. Lütfen haritadan istasyon seçin.',
                style: TextStyle(color: Colors.orange),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGasStationId,
                  isExpanded: true,
                  hint: const Text('İstasyon Seçin'),
                  items: _nearbyStations.map((station) {
                    return DropdownMenuItem<String>(
                      value: station['placeId'] as String,
                      child: Text(station['name'] as String),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedGasStationId = val),
                ),
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
                _buildSummaryRow(
                    selectedBattery == 'Akü Kontrolü' ? 'Kontrol Bedeli' : 'Akü Bedeli', batteryCost),
                _buildSummaryRow('Hizmet Bedeli', serviceFee),
                const Divider(),
                _buildSummaryRow("Toplam", total, bold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: (total > 0 && _selectedGasStationId != null)
                ? () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateOrderPage(
                          serviceType: 'battery',
                          totalAmount: total,
                          gasStationId: _selectedGasStationId,
                        ),
                      ),
                    );

                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Siparişiniz oluşturuldu')),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              "Sipariş Ver",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

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

class BatteryOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String warranty;
  final double price;
  final bool selected;
  final VoidCallback onTap;
  final String? imageAsset;

  const BatteryOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.warranty,
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
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.battery_charging_full, size: 40, color: Colors.grey),
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
                      warranty,
                      style: const TextStyle(
                        color: Colors.green,
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