import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/order_service.dart';
import '../services/gas_station_service.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += digits[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    
    for (int i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) {
        formatted += '/';
      }
      formatted += digits[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CreateOrderPage extends StatefulWidget {
  final String serviceType;
  final double totalAmount;
  final String? gasStationId;

  const CreateOrderPage({
    super.key,
    required this.serviceType,
    required this.totalAmount,
    this.gasStationId,
  });

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _addressController = TextEditingController();
  String? _selectedTime;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  String? _selectedGasStationId;
  List<Map<String, dynamic>> _nearbyStations = [];
  bool _isLoadingStations = false;

  bool _isLoading = false;
  String _error = '';

  final List<String> _timeSlots = [
    '09:00 - 11:00',
    '11:00 - 13:00',
    '13:00 - 15:00',
    '15:00 - 17:00',
    '17:00 - 19:00',
  ];

  @override
  void initState() {
    super.initState();
    _loadNearbyStations();
  }

  Future<void> _loadNearbyStations() async {
    setState(() {
      _isLoadingStations = true;
    });

    try {
      final stations = await getNearbyGasStations();
      setState(() {
        _nearbyStations = stations;
        _isLoadingStations = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Yakındaki istasyonlar yüklenirken hata oluştu: $e';
        _isLoadingStations = false;
      });
    }
  }

  Future<void> _createOrder() async {
    String cardNumberRaw = _cardNumberController.text.replaceAll(' ', '');
    String expiryRaw = _expiryController.text.replaceAll('/', '');
    if (_addressController.text.isEmpty ||
        _selectedTime == null ||
        cardNumberRaw.length != 16 ||
        expiryRaw.length != 4 ||
        _cvvController.text.length != 3 ||
        _cardHolderController.text.isEmpty) {
      setState(() => _error = 'Lütfen tüm alanları eksiksiz doldurun.');
      return;
    }

    if ((widget.serviceType == 'fuel' || widget.serviceType == 'charging') && widget.gasStationId == null) {
      setState(() => _error = 'Lütfen bir istasyon seçin.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await createOrder(
        serviceType: widget.serviceType,
        address: _addressController.text,
        totalAmount: widget.totalAmount,
        deliveryTime: _selectedTime!,
        cardNumber: cardNumberRaw.substring(12), // Son 4 hane
        cardHolder: _cardHolderController.text,
        gasStationId: widget.gasStationId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sipariş başarıyla oluşturuldu')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceType == "fuel" ? "Yakıt Siparişi Ödeme" :
          widget.serviceType == "battery" ? "Akü Siparişi Ödeme" :
          widget.serviceType == "tire" ? "Lastik Siparişi Ödeme" :
          widget.serviceType == "charging" ? "Şarj Siparişi Ödeme" :
          "Sipariş Ödeme",
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hizmet: ${widget.serviceType == "fuel" ? "Yakıt" : widget.serviceType == "battery" ? "Akü" : widget.serviceType == "tire" ? "Lastik" : widget.serviceType == "charging" ? "Şarj" : widget.serviceType}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tutar: ₺${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text('Adres', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Örn. villa 5, kapı önü vs.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Geliş Zamanı', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTime,
                items: _timeSlots.map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedTime = val),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Ödeme Bilgileri', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                inputFormatters: [CardNumberInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Kart Numarası',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      inputFormatters: [ExpiryDateInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Son Kullanma (AA/YY)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _cardHolderController,
                decoration: const InputDecoration(
                  labelText: 'Kart Sahibinin Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Siparişi Onayla'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }
} 