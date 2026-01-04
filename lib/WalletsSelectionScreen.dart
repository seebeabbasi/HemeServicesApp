// === file: WalletsSelectionScreen.dart ===
import 'package:flutter/material.dart';
import 'Confirmation.dart'; // Make sure this is the correct file name
import 'booking_model.dart'; // Import the booking model

class WalletsSelectionScreen extends StatefulWidget {
  // Add all the booking details as required parameters
  final Map<String, dynamic> service;
  final Map<String, dynamic> providers;
  final double totalPrice;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String imageUrl;
  // Added gst and couponDiscount to the constructor
  final double gst;
  final double couponDiscount;


  const WalletsSelectionScreen({
    super.key,
    required this.service,
    required this.providers,
    required this.totalPrice,
    required this.selectedDate,
    required this.selectedTime,
    required this.imageUrl,
    required this.gst,
    required this.couponDiscount,
  });

  @override
  State<WalletsSelectionScreen> createState() => _WalletsSelectionScreenState();
}

class _WalletsSelectionScreenState extends State<WalletsSelectionScreen> {
  final List<String> wallets = [
    'Paytm Wallet',
    'PhonePe Wallet',
    'Amazon Pay Wallet',
    'Freecharge Wallet',
    'Ola Money Wallet',
  ];
  String? _selectedWallet;

  // Helper function to handle navigation with all parameters
  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          service: widget.service,
          providers: widget.providers,
          totalPrice: widget.totalPrice,
          selectedDate: widget.selectedDate,
          selectedTime: widget.selectedTime,
          imageUrl: widget.imageUrl,
          gst: widget.gst,
          couponDiscount: widget.couponDiscount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Wallets',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Wallet to Pay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: _selectedWallet == wallets[index] ? 4 : 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedWallet = wallets[index];
                        });
                      },
                      child: ListTile(
                        leading: _selectedWallet == wallets[index]
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.radio_button_unchecked),
                        title: Text(wallets[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: GestureDetector(
          onTap: () {
            if (_selectedWallet != null) {
              _navigateToConfirmation();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs.${widget.totalPrice.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedWallet != null ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    color: _selectedWallet != null ? Colors.black : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
