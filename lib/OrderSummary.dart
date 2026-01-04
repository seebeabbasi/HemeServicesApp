import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Payment.dart'; // Ensure you have this file in your project.

class OrderSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final Map<String, dynamic> providers;
  final String apartmentSize;
  final String area;
  final String imageUrl;
  final String providerName;

  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const OrderSummaryScreen({
    super.key,
    required this.service,
    required this.apartmentSize,
    required this.area,
    required this.selectedDate,
    required this.selectedTime,
    required this.imageUrl,
    required this.providers,
    required this.providerName,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  int _quantity = 1;
  late double _basePrice;
  double _subtotal = 0.0;
  double _gst = 40.0;
  double _couponDiscount = 0.0; // Initialized to 0.0, will be updated by the user
  late double _totalPrice;
  bool _isBillExpanded = false;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String _address = '2nd Street, Shus Nagar, E City';
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _basePrice = double.tryParse(widget.service['price']?.toString() ?? '1120') ?? 1120.0;
    _updatePrices();
    _selectedDate = widget.selectedDate;
    _selectedTime = widget.selectedTime;
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _updatePrices() {
    _subtotal = _basePrice * _quantity;
    _totalPrice = _subtotal + _gst - _couponDiscount;
  }

  // A new method to apply the coupon based on user input
  void _applyCoupon() {
    final enteredValue = double.tryParse(_couponController.text);
    if (enteredValue != null && enteredValue >= 0) {
      setState(() {
        _couponDiscount = enteredValue;
        _updatePrices();
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _updatePrices();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _updatePrices();
      });
    }
  }

  Future<void> _showEditDateTimeDialog(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _showEditAddressDialog(BuildContext context) {
    TextEditingController addressController = TextEditingController(text: _address);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              hintText: 'Enter new address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _address = addressController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM, yyyy').format(_selectedDate);
    final String formattedTime = _selectedTime.format(context);
    final String dayOfWeek = DateFormat('EEEE').format(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Order Summary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceDetails(formattedTime, dayOfWeek),
            const SizedBox(height: 15),
            _buildAreaAndPrice(),
            const SizedBox(height: 30),
            _buildAddressSection(),
            const SizedBox(height: 30),
            _buildCouponSection(),
            const SizedBox(height: 30),
            _buildBillSection(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${_totalPrice.toInt()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      service: widget.service,
                      providers: widget.providers,
                      totalPrice: _totalPrice,
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      imageUrl: widget.imageUrl,
                      gst: _gst,
                      couponDiscount: _couponDiscount,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Proceed to Pay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetails(String formattedTime, String dayOfWeek) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service['name'] ?? 'Service Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.providers['name'] ?? 'Provider Name',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showEditDateTimeDialog(context),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('$formattedTime on $dayOfWeek',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const Icon(Icons.edit, size: 16, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _qtyButton(Icons.remove, _decrementQuantity),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('$_quantity', style: const TextStyle(fontSize: 16)),
              ),
              _qtyButton(Icons.add, _incrementQuantity),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(icon: Icon(icon, size: 18), onPressed: onTap),
    );
  }

  Widget _buildAreaAndPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text('${widget.area} Sqft', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 10),
          Container(width: 1, height: 15, color: Colors.grey[400]),
          const SizedBox(width: 10),
          Text(widget.apartmentSize, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text('₹${_basePrice.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Address', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 4),
                Text(
                  _address,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey[600]),
            onPressed: () => _showEditAddressDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          const Icon(Icons.bookmark_border, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _couponController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Apply Coupon',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: _applyCoupon,
            icon: const Icon(Icons.check, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildBillItem(String title, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            '₹${isDiscount ? '-${amount.toInt()}' : amount.toInt()}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isBillExpanded = !_isBillExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Detailed Bill', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                Icon(_isBillExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey[600]),
              ],
            ),
          ),
          if (_isBillExpanded)
            Column(
              children: [
                const Divider(height: 20, color: Colors.grey),
                _buildBillItem('Subtotal', _subtotal),
                _buildBillItem('GST', _gst),
                _buildBillItem('Coupon Discount', _couponDiscount, isDiscount: true),
                const Divider(height: 20, color: Colors.grey),
              ],
            ),
          _buildBillItem('Total', _totalPrice, isTotal: true),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
