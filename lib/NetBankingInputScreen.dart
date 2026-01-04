// === file: NetBankingInputScreen.dart ===
import 'package:flutter/material.dart';
import 'Confirmation.dart'; // Make sure this is the correct file name
import 'booking_model.dart'; // Import the booking model

class NetBankingInputScreen extends StatefulWidget {
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


  const NetBankingInputScreen({
    super.key,
    required this.service,
    required this.providers,
    required this.totalPrice,
    required this.selectedDate,
    required this.selectedTime,
    required this.imageUrl,
    // Add required properties for gst and couponDiscount
    required this.gst,
    required this.couponDiscount,
  });

  @override
  State<NetBankingInputScreen> createState() => _NetBankingInputScreenState();
}

class _NetBankingInputScreenState extends State<NetBankingInputScreen> {
  final List<String> banks = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Punjab National Bank',
    'Kotak Mahindra Bank',
  ];
  String? _selectedBank;

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
          // Pass the gst and couponDiscount to the ConfirmationScreen
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
          'Net Banking',
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
              'Select Your Bank',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: banks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: _selectedBank == banks[index] ? 4 : 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedBank = banks[index];
                        });
                      },
                      child: ListTile(
                        leading: _selectedBank == banks[index]
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.radio_button_unchecked),
                        title: Text(banks[index]),
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
            if (_selectedBank != null) {
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
                  color: _selectedBank != null ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    color: _selectedBank != null ? Colors.black : Colors.white,
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
