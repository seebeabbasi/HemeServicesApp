
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'booking_manager.dart';
import 'booking_model.dart';
import 'main.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> service;
  final Map<String, dynamic> providers;
  final double totalPrice;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String imageUrl;
  // Added gst and couponDiscount to the constructor
  final double gst;
  final double couponDiscount;


  const ConfirmationScreen({
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingManager = Provider.of<BookingManager>(context, listen: false);
      final confirmedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Format the date and time for the message
      final formattedDateTime = DateFormat('EEE, d MMM, yyyy h:mm a').format(confirmedDateTime);

      final newBooking = Booking(
        serviceName: service['name'] ?? 'Unknown Service',
        providerName: providers['name'] ?? 'Unknown Provider',
        imageUrl: imageUrl,
        dateTime: confirmedDateTime,
        price: totalPrice,
        status: BookingStatus.inProcess,
        // Construct the custom message with the formatted time
        message: 'Thank you for order service using the app! Your appointment is scheduled for $formattedDateTime.',
        // Pass the gst and couponDiscount to the Booking object
        gst: gst,
        couponDiscount: couponDiscount,
      );

      if (!bookingManager.activeBookings.any((b) => b.serviceName == newBooking.serviceName && b.dateTime == newBooking.dateTime)) {
        bookingManager.addBooking(newBooking);
      }
    });

    // ... rest of the ConfirmationScreen build method remains the same ...
    final formattedDate = DateFormat('d MMM, yyyy').format(selectedDate);
    final formattedTime = selectedTime.format(context);
    final dayOfWeek = DateFormat('EEEE').format(selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirmed',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                'Your booking has been confirmed for $formattedDate',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'You will get an email with the booking details',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 24, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '$formattedTime on $dayOfWeek',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FullAppsScreen()),
                  (route) => false,
            );
          },
          child: const Text('Go Back Home', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
