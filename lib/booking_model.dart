// lib/booking_model.dart
import 'package:flutter/material.dart';

enum BookingStatus {
  inProcess,
  assigned,
  completed,
  cancelled,
}

class Booking {
  final String serviceName;
  final String providerName;
  final String imageUrl;
  final DateTime dateTime;
  final double price;
  final BookingStatus status;
  final String message;
  // Added new properties for GST and coupon discount
  final double gst;
  final double couponDiscount;


  Booking({
    required this.serviceName,
    required this.providerName,
    required this.imageUrl,
    required this.dateTime,
    required this.price,
    required this.status,
    this.message = 'Thank you for order service using the app!',
    required this.gst,
    required this.couponDiscount,
  });
}
