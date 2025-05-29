import 'package:flutter/material.dart';

class Vehicle {
  final String name;
  final String plate;
  final IconData icon;
  final String? logoAsset;

  Vehicle({
    required this.name,
    required this.plate,
    required this.icon,
    this.logoAsset,
  });
}

class VehicleSelector extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Vehicle? initialVehicle;
  final void Function(Vehicle) onChanged;

  const VehicleSelector({
    super.key,
    required this.vehicles,
    required this.onChanged,
    this.initialVehicle,
  });

  @override
  State<VehicleSelector> createState() => _VehicleSelectorState();
}

class _VehicleSelectorState extends State<VehicleSelector> {
  late Vehicle selectedVehicle;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.initialVehicle ?? widget.vehicles.first;
  }

  void _showVehicleSheet() async {
    final Vehicle? result = await showModalBottomSheet<Vehicle>(
      context: context,
      isScrollControlled: true, // Modal yüksekliğini ekran boyuna göre ayarla
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Araçlarım",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Yeni araç ekleme yakında!")),
                            );
                          },
                          child: const Text("Yeni Ekle"),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...widget.vehicles.map((vehicle) {
                      final isSelected = vehicle == selectedVehicle;
                      return ListTile(
                        leading: vehicle.logoAsset != null
                            ? Image.asset(vehicle.logoAsset!, width: 32, height: 32)
                            : Icon(vehicle.icon, color: Colors.blue, size: 32),
                        title: Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(vehicle.plate),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.teal)
                            : null,
                        onTap: () => Navigator.of(context).pop(vehicle),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && result != selectedVehicle) {
      setState(() => selectedVehicle = result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showVehicleSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // Tüm alanı kapla
          children: [
            selectedVehicle.logoAsset != null
                ? Image.asset(selectedVehicle.logoAsset!, width: 32, height: 32)
                : Icon(selectedVehicle.icon, color: Colors.blue, size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedVehicle.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    selectedVehicle.plate,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}