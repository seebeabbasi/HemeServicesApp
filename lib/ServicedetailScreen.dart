import 'package:flutter/material.dart';
import 'BookingScreen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> services;
  final Map<String, dynamic> service;

  const ServiceDetailScreen({super.key, required this.services, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  List<Map<String, dynamic>> filteredServices = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    filteredServices = widget.services;
  }

  void updateSearch(String input) {
    setState(() {
      query = input.toLowerCase();
      filteredServices = widget.services.where((service) {
        final providerName = service['provider_name'].toLowerCase();
        final title = service['title'].toLowerCase();
        return providerName.contains(query) || title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Service Details', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search provider or service...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
              ),
              onChanged: updateSearch,
            ),
          ),

          // List of Filtered Services
          Expanded(
            child: ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Provider Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            service['path'],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 150,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Provider Name - Correctly displaying the name
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            service['provider_name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Rating
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '⭐${service['rating']} (${service['reviews']} jobs)',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Service Title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            service['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Hourly Rate
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            service['hourly_rate'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Book Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  service: service,
                                  providerName: service['provider_name'], // Correctly passing the provider name
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Book',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}