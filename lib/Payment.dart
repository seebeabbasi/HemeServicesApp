// === file: PaymentScreen.dart ===
import 'package:flutter/material.dart';
import 'Confirmation.dart'; // Import the ConfirmationScreen (Note: Corrected file name)
import 'CreditCardInputScreen.dart'; // Import the CreditCardInputScreen
import 'NetBankingInputScreen.dart'; // Import the new NetBankingInputScreen
import 'WalletsSelectionScreen.dart'; // Import the new WalletsSelectionScreen
import 'booking_model.dart'; // To potentially use this later if needed

class PaymentScreen extends StatelessWidget {
  // New required parameters to pass data to the ConfirmationScreen
  final Map<String, dynamic> service;
  final Map<String, dynamic> providers;
  final double totalPrice;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String imageUrl;
  // Added gst and couponDiscount to the constructor
  final double gst;
  final double couponDiscount;

  const PaymentScreen({
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
  Widget build(BuildContext context) {
    // This function now passes all the necessary data.
    void navigateToConfirmation() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            service: service,
            providers: providers,
            totalPrice: totalPrice,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            imageUrl: imageUrl,
            gst: gst,
            couponDiscount: couponDiscount,
          ),
        ),
      );
    }

    // This function shows a confirmation dialog for Cash on Delivery.
    void showCashOnDeliveryDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Order'),
            content: Text('Your order amount is Rs.${totalPrice.toInt()}. Do you want to pay with Cash on Delivery?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  navigateToConfirmation(); // Navigate to the confirmation screen
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit & Debit Cards option, now navigates to the card input screen with all booking data
            _buildPaymentOption(
              context,
              'Credit & Debit Cards',
              Icons.credit_card,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreditCardInputScreen(
                    service: service,
                    providers: providers,
                    totalPrice: totalPrice,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    imageUrl: imageUrl,
                    gst: gst,
                    couponDiscount: couponDiscount,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            // Net Banking option, now navigates to the new Net Banking input screen with all booking data
            _buildPaymentOption(
              context,
              'Net Banking',
              Icons.account_balance,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NetBankingInputScreen(
                    service: service,
                    providers: providers,
                    totalPrice: totalPrice,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    imageUrl: imageUrl,
                    gst: gst,
                    couponDiscount: couponDiscount,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            // Cash On Delivery option, now shows a confirmation dialog
            _buildPaymentOption(
              context,
              'Cash On Delivery',
              Icons.money,
              showCashOnDeliveryDialog,
            ),
            const SizedBox(height: 15),
            // Wallets option, now navigates to the new Wallets selection screen with all booking data
            _buildPaymentOption(
              context,
              'Wallets',
              Icons.wallet,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletsSelectionScreen(
                    service: service,
                    providers: providers,
                    totalPrice: totalPrice,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    imageUrl: imageUrl,
                    gst: gst,
                    couponDiscount: couponDiscount,
                  )),
                );
              },
            ),
            const SizedBox(height: 30),

            // UPIs Section
            const Text(
              'UPIs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                // All UPI options now navigate to confirmation
                _buildUpiOption(
                  context,
                  'Paytm',
                  'assets/images/paytm_logo.jpg',
                  navigateToConfirmation,
                ),
                _buildUpiOption(
                  context,
                  'PhonePe',
                  'assets/images/phonepe_logo.jpg',
                  navigateToConfirmation,
                ),
                _buildUpiOption(
                  context,
                  'Amazon Pay',
                  'assets/images/amazonpay_logo.jpg',
                  navigateToConfirmation,
                ),
                _buildUpiOption(
                  context,
                  'Free charge',
                  'assets/images/freecharge_logo.jpg',
                  navigateToConfirmation,
                ),
                _buildUpiOption(
                  context,
                  'Ola Money',
                  'assets/images/olamoney_logo.jpg',
                  navigateToConfirmation,
                ),
              ],
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
          onTap: navigateToConfirmation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs.${totalPrice.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    color: Colors.black,
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

  // The _buildPaymentOption method now takes an onTap function
  Widget _buildPaymentOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell( // Using InkWell for a tap-and-ripple effect
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
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
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // The _buildUpiOption method also now takes an onTap function
  Widget _buildUpiOption(
      BuildContext context, String name, String imagePath, VoidCallback onTap) {
    return InkWell( // Using InkWell for a tap-and-ripple effect
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
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
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
