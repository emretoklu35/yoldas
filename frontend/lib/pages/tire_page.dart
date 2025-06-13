// File: lib/pages/tire_page.dart
import 'package:flutter/material.dart';
import 'checkout_page.dart';
import 'create_order_page.dart';
import '../services/gas_station_service.dart';

class TirePage extends StatefulWidget {
  const TirePage({super.key});

  @override
  State<TirePage> createState() => _TirePageState();
}

class _TirePageState extends State<TirePage> {
  final Map<String, int> _selectedTires = {};
  String? _selectedGasStationId;
  List<Map<String, dynamic>> _nearbyStations = [];
  bool _isLoadingStations = false;
  String _stationError = '';

  final List<Map<String, dynamic>> tireProducts = [
    {
      'id': '1',
      'name': 'PILOT SPORT CUP 2',
      'brand': 'Michelin',
      'size': '245 / 35 / R19',
      'origin': 'Fransa',
      'year': 2024,
      'warranty': '5 yıl garanti',
      'price': 1508,
      'currency': 'TRY',
      'imageAsset': 'https://cdn.servislet.com/tire-category-asset/michelin/pilot-sport-cup-2-400x400.webp',
      'tags': ['İndirim', 'Tavsiye Edilen'],
    },
    {
      'id': '2',
      'name': 'PRIMACY 4+',
      'brand': 'Michelin',
      'size': '215 / 55 / R18',
      'origin': 'İspanya',
      'year': 2024,
      'warranty': '5 yıl garanti',
      'price': 1037,
      'currency': 'TRY',
      'imageAsset': 'https://productimages.hepsiburada.net/s/777/424-600/110000964052552.jpg/format:webp',
      'tags': ['İndirim', 'Tavsiye Edilen'],
    },
    {
      'id': '3',
      'name': 'PILOT SPORT 4 S',
      'brand': 'Michelin',
      'size': '225 / 35 / R19',
      'origin': 'Fransa',
      'year': 2024,
      'warranty': '5 yıl garanti',
      'price': 1238,
      'currency': 'TRY',
      'imageAsset': 'https://cdn.servislet.com/tire-category-asset/michelin/pilot-sport-41659082102-400x400.webp',
      'tags': ['İndirim', 'Tavsiye Edilen'],
    },
    {
      'id': '4',
      'name': 'PILOT SPORT 4 S',
      'brand': 'Michelin',
      'size': '235 / 40 / R19',
      'origin': 'Fransa',
      'year': 2024,
      'warranty': '5 yıl garanti',
      'price': 1350,
      'currency': 'TRY',
      'imageAsset': 'https://cdn.servislet.com/tire-category-attachment-asset/michelin/1sg3DBLYkYcHaxhp5efscBwk8IPpLHBd92LcRvGg.webp',
      'tags': ['İndirim', 'Tavsiye Edilen'],
    },
  ];

  final List<String> tireSizes = [
    'Hepsi',
    '245 / 35 / R19',
    '215 / 55 / R18',
    '225 / 35 / R19',
    '235 / 40 / R19'
  ];
  final List<String> tireBrands = ['Hepsi', 'Michelin', 'Goodyear', 'Pirelli'];

  String? selectedSize = 'Hepsi';
  String? selectedBrand = 'Hepsi';

  List<Map<String, dynamic>> get _filteredTires {
    return tireProducts.where((tire) {
      final bool sizeMatch = selectedSize == 'Hepsi' || tire['size'] == selectedSize;
      final bool brandMatch = selectedBrand == 'Hepsi' || tire['brand'] == selectedBrand;
      return sizeMatch && brandMatch;
    }).toList();
  }

  double get _calculateTotal {
    double total = 0;
    _selectedTires.forEach((tireId, quantity) {
      final tire = tireProducts.firstWhere((t) => t['id'] == tireId, orElse: () => {});
      if (tire.isNotEmpty) {
        total += (tire['price'] as num).toDouble() * quantity;
      }
    });
    return total;
  }

  void _toggleTireSelection(String tireId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _selectedTires.remove(tireId);
      } else {
        _selectedTires[tireId] = quantity;
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
        title: const Text('Lastik Siparişi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedSize,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        onChanged: (value) {
                          setState(() {
                            selectedSize = value;
                          });
                        },
                        items: tireSizes.map((size) => DropdownMenuItem(
                          value: size,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (size != selectedSize)
                                Text(
                                  'Lastik Boyutu:',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              Text(
                                size,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )).toList(),
                        selectedItemBuilder: (context) => tireSizes.map((size) => Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Lastik Boyutu:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  Text(size, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedBrand,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        onChanged: (value) {
                          setState(() {
                            selectedBrand = value;
                          });
                        },
                        items: tireBrands.map((brand) => DropdownMenuItem(
                          value: brand,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (brand != selectedBrand)
                                Text(
                                  'Marka:',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              Text(
                                brand,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )).toList(),
                        selectedItemBuilder: (context) => tireBrands.map((brand) => Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Marka:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  Text(brand, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredTires.length,
                itemBuilder: (context, index) {
                  final tire = _filteredTires[index];
                  final int currentQuantity = _selectedTires[tire['id']] ?? 0;
                  return TireProductCard(
                    product: tire,
                    quantity: currentQuantity,
                    onQuantityChanged: (newQuantity) {
                      _toggleTireSelection(tire['id'], newQuantity);
                    },
                  );
                },
              ),
            ),
          ),
          if (_calculateTotal > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Lastik İstasyonu Seçimi",
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Toplam Tutar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '₺${_calculateTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_calculateTotal > 0 && _selectedGasStationId != null)
                            ? () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateOrderPage(
                                      serviceType: 'tire',
                                      totalAmount: _calculateTotal,
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
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Sipariş Ver',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TireProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const TireProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = quantity > 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          final newQuantity = isSelected ? quantity + 1 : 1;
          onQuantityChanged(newQuantity);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product['imageAsset'],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.tire_repair,
                        size: 30,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              if (product['tags'] != null && (product['tags'] as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: (product['tags'] as List<String>).map((tag) {
                      bool isIndirim = tag == 'İndirim';
                      return Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isIndirim ? const Color(0xFFF5E6C6) : const Color(0xFFD6F4FB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: isIndirim ? const Color(0xFF8B4513) : const Color(0xFF00BCD4),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              Text(
                '${product['brand']} ${product['name']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                product['size'],
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${product['origin']} • ${product['year']}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product['warranty'],
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '₺${(product['price'] as num).toStringAsFixed(0)}', // Updated to use ₺
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        color: Colors.black,
                        onPressed: () {
                          if (quantity > 0) {
                            onQuantityChanged(quantity - 1);
                          }
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        visualDensity: VisualDensity.compact,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        color: Colors.black,
                        onPressed: () {
                          onQuantityChanged(quantity + 1);
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}