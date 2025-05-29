import 'package:flutter/material.dart';
import 'checkout_page.dart';

class TirePage extends StatefulWidget {
  const TirePage({super.key});

  @override
  State<TirePage> createState() => _TirePageState();
}

class _TirePageState extends State<TirePage> {
  // Removed service-based selection
  // String? selectedTireOption;
  // double tireCost = 0;
  // double serviceFee = 80;
  // double total = 0;

  // Using a list to hold selected tire products and quantities
  final Map<String, int> _selectedTires = {}; // Map of tire name to quantity

  final List<Map<String, dynamic>> tireProducts = [
    {
      'name': 'Michelin PILOT SPORT CUP 2',
      'brand': 'Michelin',
      'size': '245 / 35 R19',
      'origin': 'France',
      'year': 2024,
      'warranty': '5 years warranty',
      'price': 1508,
      'imageAsset': 'assets/images/michelin_cup2.png', // Placeholder
      'tags': ['Sale', 'Recommended'],
    },
    {
      'name': 'Michelin PRIMACY 4+',
      'brand': 'Michelin',
      'size': '215 / 55 R18',
      'origin': 'Spain',
      'year': 2024,
      'warranty': '5 years warranty',
      'price': 1037,
      'imageAsset': 'assets/images/michelin_primacy4.png', // Placeholder
      'tags': ['Sale', 'Recommended'],
    },
    {
      'name': 'Michelin PILOT SPORT 4 S',
      'brand': 'Michelin',
      'size': '225 / 35 R19',
      'origin': 'France',
      'year': 2024,
      'warranty': '5 years warranty',
      'price': 1238,
      'imageAsset': 'assets/images/michelin_ps4s_1.png', // Placeholder
      'tags': ['Sale', 'Recommended'],
    },
    {
      'name': 'Michelin PILOT SPORT 4 S',
      'brand': 'Michelin',
      'size': '235 / 40 R19',
      'origin': 'France',
      'year': 2024,
      'warranty': '5 years warranty',
      'price': 1350,
      'imageAsset': 'assets/images/michelin_ps4s_2.png', // Placeholder
      'tags': ['Sale', 'Recommended'],
    },
    // Add more tire products here
  ];

  // Placeholder filter options
  final List<String> tireSizes = ['All', '245 / 35 R19', '215 / 55 R18', '225 / 35 R19', '235 / 40 R19'];
  final List<String> tireBrands = ['All', 'Michelin', 'Goodyear', 'Pirelli']; // Example brands

  String? selectedSize = 'All';
  String? selectedBrand = 'All';

  List<Map<String, dynamic>> get _filteredTires {
    return tireProducts.where((tire) {
      final bool sizeMatch = selectedSize == 'All' || tire['size'] == selectedSize;
      final bool brandMatch = selectedBrand == 'All' || tire['brand'] == selectedBrand;
      return sizeMatch && brandMatch;
    }).toList();
  }

  double get _calculateTotal {
    double total = 0;
    _selectedTires.forEach((tireName, quantity) {
      final tire = tireProducts.firstWhere((t) => t['name'] == tireName); // Assuming tire name is unique for simplicity
      total += (tire['price'] as num).toDouble() * quantity;
    });
    return total;
  }

  // Function to add/remove tire from selection
  void _toggleTireSelection(String tireName, int quantity) {
    setState(() {
      if (_selectedTires.containsKey(tireName)) {
        if (quantity > 0) {
          _selectedTires[tireName] = quantity; // Update quantity
        } else {
          _selectedTires.remove(tireName); // Remove if quantity is 0
        }
      } else if (quantity > 0) {
        _selectedTires[tireName] = quantity; // Add if not selected
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Default selection or calculation can be added here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lastikler'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSize,
                    decoration: InputDecoration(
                      labelText: 'Lastik Boyutu',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.aspect_ratio),
                    ),
                    items: tireSizes.map((size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedBrand,
                    decoration: InputDecoration(
                      labelText: 'Marka',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.business),
                    ),
                    items: tireBrands.map((brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBrand = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7, // Adjust as needed based on content
              ),
              itemCount: _filteredTires.length,
              itemBuilder: (context, index) {
                final tire = _filteredTires[index];
                final int currentQuantity = _selectedTires[tire['name']] ?? 0;
                return TireProductCard(
                  product: tire,
                  quantity: currentQuantity,
                  onQuantityChanged: (newQuantity) {
                    _toggleTireSelection(tire['name'] as String, newQuantity);
                  },
                );
              },
            ),
          ),
          // Summary and Checkout button at the bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryRow('Toplam Lastik Bedeli', _calculateTotal),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _calculateTotal > 0
                      ? () {
                          // Navigate to CheckoutPage with selected tires and total
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(
                                fuelCost: _calculateTotal, // Use total here
                                serviceFee: 0, // Service fee might be calculated differently now or on checkout
                                serviceType: 'tire',
                                // You might need to pass selected tires details as well
                                // selectedItems: _selectedTires,
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
                    minimumSize: Size(double.infinity, 50), // Make button full width
                  ),
                  child: const Text(
                    "Devam Et",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reused from previous implementation
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

// New widget to display individual tire products
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.teal : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Simple toggle: if selected, remove; if not selected, add 1
          onQuantityChanged(isSelected ? 0 : 1);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product['imageAsset'] != null)
                Expanded(
                  child: Center(
                    child: Image.asset(
                      product['imageAsset']!,
                      // width: double.infinity, // Take available width
                      // height: 80, // Fixed height, adjust as needed
                      fit: BoxFit.contain, // Adjust as needed
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.tire_repair, size: 50, color: Colors.grey), // Placeholder icon on error
                    ),
                  ),
                ) else Expanded(child: Center(child: Icon(Icons.tire_repair, size: 50, color: Colors.grey))), // Placeholder if no image asset
              const SizedBox(height: 8),
              // Tags like 'Sale' or 'Recommended'
              if (product['tags'] != null && product['tags'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: (product['tags'] as List<String>).map((tag) => Chip(
                      label: Text(tag, style: TextStyle(fontSize: 10)),
                      backgroundColor: tag == 'Sale' ? Colors.orange.shade100 : Colors.blue.shade100,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),
                ),
              Text(
                product['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Adjust font size
                maxLines: 2, // Limit lines
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product['size'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.grey), // Adjust font size
              ),
              Text(
                '${product['origin']} • ${product['year']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey), // Adjust font size
              ),
               Text(
                product['warranty'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                     '₺${(product['price'] as num).toDouble().toStringAsFixed(2)}',
                     style: const TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.teal,
                     ),
                   ),
                    // Quantity control
                    if (isSelected)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: () => onQuantityChanged(quantity - 1),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Text(quantity.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () => onQuantityChanged(quantity + 1),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ) else // Show Add button or similar if not selected
                      TextButton( // Or ElevatedButton, IconButton etc.
                        onPressed: () => onQuantityChanged(1), // Add 1 when tapped
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          minimumSize: Size(0,0)
                        ),
                        child: const Text('Ekle'),
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