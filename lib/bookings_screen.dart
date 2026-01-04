// lib/bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'CancelBookingScreen.dart';
import 'booking_manager.dart';
import 'booking_model.dart';
import 'main.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingManager>(
      builder: (context, bookingManager, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Bookings',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(bookingManager.activeBookings, isHistory: false),
              _buildBookingList(bookingManager.historyBookings, isHistory: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingList(List<Booking> bookings, {required bool isHistory}) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings to display.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking, isHistory);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, bool isHistory) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.serviceName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  _getStatusText(booking.status),
                  style: TextStyle(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                      Text(
                        booking.providerName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            '${DateFormat('MMM d, yyyy').format(booking.dateTime)} at ${DateFormat('h:mm a').format(booking.dateTime)}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${booking.price.toInt()}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const Divider(height: 25),
            Center(
              child: isHistory
                  ? TextButton(
                onPressed: () {
                  // Show confirmation dialog for "Book Again"
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Booking'),
                        content: const Text('Are you sure you want to book this service again?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('No', style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              // Navigate to the home screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FullAppsScreen()),
                              );
                            },
                            child: const Text('Yes', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Book Again',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              )
                  : TextButton(
                onPressed: () {
                  // Navigate to the cancellation screen, passing the GST and coupon discount.
                  // This assumes that the 'Booking' model has 'gst' and 'couponDiscount' properties.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CancelBookingScreen(
                        booking: booking,
                        gst: booking.gst,
                        couponDiscount: booking.couponDiscount,
                      ),
                    ),
                  );
                },
                child: const Text('Cancel',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProcess: return 'In Process';
      case BookingStatus.assigned: return 'Assigned';
      case BookingStatus.completed: return 'Completed';
      case BookingStatus.cancelled: return 'Cancelled';
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProcess: return Colors.orange;
      case BookingStatus.assigned: return Colors.blue;
      case BookingStatus.completed: return Colors.green;
      case BookingStatus.cancelled: return Colors.red;
    }
  }
}
