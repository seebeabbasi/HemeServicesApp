import 'package:flutter/material.dart';
import 'ServicedetailScreen.dart';
import 'CleaningTypeScreen.dart';
import 'plumberTypeScreen.dart';
import 'ElectritionTypeScreen.dart';
import 'PaintingTypeScreen.dart';
import 'CarapenterTypeScreen.dart';
import 'BookingScreen.dart'; // Make sure this is imported

class HomeServiceScreen extends StatefulWidget {
  final String? initialSearchQuery;
  const HomeServiceScreen({super.key, this.initialSearchQuery});

  @override
  State<HomeServiceScreen> createState() => _HomeServiceScreenState();
}

class _HomeServiceScreenState extends State<HomeServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredServices = [];

  final List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Plumber',
      'description': 'Custom pipe and motor installation/repair.',
      'provider_name': 'Michel Smith',
      'rating': '3.5',
      'reviews': '120',
      'hourly_rate': '₹330/hr',
      'path': 'assets/images/plumbing.jpg', // Ensure you have this image
    },
    {
      'title': 'Electrician',
      'description': 'Wiring, circuit, and appliance fixes.',
      'provider_name': 'Smith',
      'rating': '4.7',
      'reviews': '95',
      'hourly_rate': '₹400/hr',
      'path': 'assets/images/electrician.jpg', // Ensure you have this image
    },
    {
      'title': 'Cleaning',
      'description': 'Deep cleaning for homes and offices.',
      'provider_name': 'John Smith',
      'rating': '3.5',
      'reviews': '110',
      'hourly_rate': '₹150/hr',
      'path': 'assets/images/cleaning.jpg', // Ensure you have this image
    },
    {
      'title': 'Carpenter',
      'description': 'Custom furniture, repairs, and woodworks.',
      'provider_name': 'John Carter',
      'rating': '4.5',
      'reviews': '80',
      'hourly_rate': '₹250/hr',
      'path': 'assets/images/carpenter.jpg', // Ensure you have this image
    },
    {
      'title': 'Painting',
      'description': 'Interior and exterior painting services.',
      'provider_name': 'Carry Lain',
      'rating': '3.5',
      'reviews': '150',
      'hourly_rate': '₹100/hr',
      'path': 'assets/images/painter.jpg', // Ensure you have this image
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredServices = _allServices;
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
      _filterAndSortServices(widget.initialSearchQuery!);
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterAndSortServices(_searchController.text);
  }

  void _filterAndSortServices(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _allServices;
      } else {
        final lowerCaseQuery = query.toLowerCase();

        // Prioritized matches: service title or provider name contains query
        List<Map<String, dynamic>> prioritized = [];
        List<Map<String, dynamic>> others = [];

        for (var service in _allServices) {
          final titleLower = service['title'].toLowerCase();
          final providerLower = service['provider_name'].toLowerCase();

          // Check if the lowercase title or provider name contains the lowercase query
          if (titleLower.contains(lowerCaseQuery) || providerLower.contains(lowerCaseQuery)) {
            prioritized.add(service);
          } else {
            others.add(service);
          }
        }

        _filteredServices = [...prioritized, ...others];
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Service Providers', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for services or providers...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredServices.isEmpty
                  ? Center(
                child: Text(
                  'No services found for "${_searchController.text}"',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  return _buildServiceProviderCard(context, service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildServiceProviderCard(BuildContext context, Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Provider Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              service['path'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Provider Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['provider_name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  service['title'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      service['rating'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  service['hourly_rate'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Book Button
          ElevatedButton(
            onPressed: () {
              // Now passes the provider name and title correctly
              if (service['title'] == 'Cleaning') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CleaningTypeScreen(serviceProvider: service),
                  ),
                );
              } else if (service['title'] == 'Plumber') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlumberTypeScreen(serviceProvider: service),
                  ),
                );
              }
              else if (service['title'] == 'Electrician') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Electritiontypescreen(serviceProvider: service),
                  ),
                );
              }
              else if (service['title'] == 'Painting') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Paintingtypescreen(serviceProvider: service),
                  ),
                );
              }
              else if (service['title'] == 'Carpenter') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Carpentertypescreen(serviceProvider: service),
                  ),
                );
              }
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailScreen(service: service, services: [],),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }
}