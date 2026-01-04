// lib/booking_manager.dart
import 'package:flutter/material.dart';
import 'booking_model.dart';

class BookingManager with ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get activeBookings => _bookings.where((b) => b.status == BookingStatus.inProcess || b.status == BookingStatus.assigned).toList();
  List<Booking> get historyBookings => _bookings.where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled).toList();

  void addBooking(Booking newBooking) {
    _bookings.add(newBooking);
    notifyListeners();
  }

  void updateBookingStatus(Booking booking, BookingStatus newStatus) {
    final index = _bookings.indexOf(booking);
    if (index != -1) {
      _bookings[index] = Booking(
        serviceName: booking.serviceName,
        providerName: booking.providerName,
        imageUrl: booking.imageUrl,
        dateTime: booking.dateTime,
        price: booking.price,
        status: newStatus,
        // Added the required gst and couponDiscount properties.
        gst: booking.gst,
        couponDiscount: booking.couponDiscount,
      );
      notifyListeners();
    }
  }
}
