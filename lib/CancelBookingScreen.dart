// lib/cancel_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'booking_model.dart';
import 'booking_manager.dart';
import 'CancelledScreen.dart';

enum RefundMethod { originalPayment, wallet }
enum CancelReason { mistake, notAvailable, noLongerNeeded }

class CancelBookingScreen extends StatefulWidget {
  final Booking booking;
  final double gst;
  final double couponDiscount;

  const CancelBookingScreen({
    super.key,
    required this.booking,
    required this.gst,
    required this.couponDiscount,
  });

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  RefundMethod _selectedRefundMethod = RefundMethod.originalPayment;
  CancelReason _selectedCancelReason = CancelReason.mistake;

  @override
  Widget build(BuildContext context) {
    // Calculate final total based on dynamic values
    final subtotal = widget.booking.price;
    final gst = widget.gst;
    final couponDiscount = widget.couponDiscount;
    final total = (subtotal + gst - couponDiscount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cancel Booking',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingDetailsCard(widget.booking),
              const SizedBox(height: 20),
              _buildOrderSummary(subtotal, gst, couponDiscount, total),
              const SizedBox(height: 20),
              _buildRefundMethod(),
              const SizedBox(height: 20),
              _buildCancelReason(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Update booking status to cancelled
              Provider.of<BookingManager>(context, listen: false)
                  .updateBookingStatus(widget.booking, BookingStatus.cancelled);
              // Navigate to success screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const CancelledScreen()),
                    (Route<dynamic> route) => route.isFirst,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Cancel Service',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard(Booking booking) {
    // Re-use the card layout for the top section
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(booking.serviceName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(booking.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.providerName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('h:mm a').format(booking.dateTime)} on ${DateFormat('EEEE').format(booking.dateTime)}',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${booking.price.toInt()}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('1590 Sqft', style: TextStyle(color: Colors.black)),
                Text('3BHK', style: TextStyle(color: Colors.black)),
                // The image shows editable quantity, but your initial image doesn't.
                // We'll just show the price.
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double gst, double discount, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        _buildSummaryRow('Subtotal', '₹${subtotal.toInt()}'),
        _buildSummaryRow('GST', '₹${gst.toInt()}'),
        _buildSummaryRow('Coupon Discount', '- ₹${discount.toInt()}'),
        const Divider(height: 25),
        _buildSummaryRow('Total', '₹${total.toInt()}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : Colors.grey[700])),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildRefundMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Refund Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
        ),
        _buildRadioTile(
          'Refund to Original Payment Method',
          RefundMethod.originalPayment,
          _selectedRefundMethod,
              (value) {
            setState(() {
              _selectedRefundMethod = value!;
            });
          },
        ),
        _buildRadioTile(
          'Add to My Wallet',
          RefundMethod.wallet,
          _selectedRefundMethod,
              (value) {
            setState(() {
              _selectedRefundMethod = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCancelReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why are you cancelling this service',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        _buildRadioTile(
          'Booked by mistake',
          CancelReason.mistake,
          _selectedCancelReason,
              (value) {
            setState(() {
              _selectedCancelReason = value!;
            });
          },
        ),
        _buildRadioTile(
          'Not available on the date of service',
          CancelReason.notAvailable,
          _selectedCancelReason,
              (value) {
            setState(() {
              _selectedCancelReason = value!;
            });
          },
        ),
        _buildRadioTile(
          'No longer needed',
          CancelReason.noLongerNeeded,
          _selectedCancelReason,
              (value) {
            setState(() {
              _selectedCancelReason = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRadioTile<T>(String title, T value, T groupValue, ValueChanged<T?> onChanged) {
    return RadioListTile<T>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.orange, // Based on the image
    );
  }
}
