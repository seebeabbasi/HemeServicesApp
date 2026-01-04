// lib/ElectritionTypeScreen.dart
import 'package:flutter/material.dart';
import 'BookingScreen.dart';
import 'ChatScreen.dart'; // Assuming you have a BookingScreen

class Electritiontypescreen extends StatelessWidget {
  final Map<String, dynamic> serviceProvider; // To pass provider details if needed

  const Electritiontypescreen({super.key, required this.serviceProvider});

  final List<Map<String, dynamic>> _ElectritionTypes = const [
    {
      'name': 'Wiring Fix',
      'price': '750', // Changed to just number
      'image_path': 'assets/images/WiringFix.jpg', // Corrected key
    },
    {
      'name': 'Appliance Installation',
      'price': '1000', // Changed to just number
      'image_path': 'assets/images/ApplianceInstallation.jpg', // Corrected key
    },
    {
      'name': 'Electrical Fault Repair', // New service name
      'price': '1200', // Example price
      'image_path': 'assets/images/ElectricalFaultRepair.jpg', // Assuming you'll add this image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          serviceProvider['title'] ?? 'Electronic Services',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity, // Take full width
            height: 200, // Adjust height as needed
            child: Image.asset(
              'assets/images/bedroom_header.jpg', // Path to your new image
              fit: BoxFit.cover, // Cover the container, cropping if necessary
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _ElectritionTypes.length,
              itemBuilder: (context, index) {
                final type = _ElectritionTypes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(service: type, providerName: 'Smith',),
                      ),
                    );
                  },
                  child: _buildElectritionTypeCard(type), // Renamed for clarity
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            providerName: serviceProvider['provider_name'] ?? 'Service Provider',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline),
                        SizedBox(width: 8),
                        Text('Chat'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(
                            service: _ElectritionTypes[0], // Pass the first cleaning type (or any selected one)
                            providerName: serviceProvider['provider_name'] ?? '',),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Book'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Renamed from _buildCleaningTypeCard to _buildElectritionTypeCard for clarity
  Widget _buildElectritionTypeCard(Map<String, dynamic> type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              type['image_path'], // Corrected: use 'image_path'
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type['name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${type['price']} onwards', // Displaying 'Rs.' prefix
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
