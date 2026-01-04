// lib/PopularServicesScreen.dart
import 'package:flutter/material.dart';
import 'HomeScreen.dart'; // Assuming HomeServiceScreen is in HomeScreen.dart if needed for navigation

class PopularServicesScreen extends StatelessWidget {
  const PopularServicesScreen({super.key});

  final List<Map<String, String>> popularServices = const [
    {'image': 'assets/images/plumber_provider.jpg', 'name': 'Plumbing Pro', 'rating': '4.8', 'reviews': '120'},
    {'image': 'assets/images/electrician_provider.jpg', 'name': 'Sparky Electric', 'rating': '4.7', 'reviews': '95'},
    {'image': 'assets/images/Ali_painter.jpg', 'name': 'Artistic Painter', 'rating': '4.9', 'reviews': '150'},
    {'image': 'assets/images/Carpenter_provider.jpeg', 'name': 'Wood Craftsman', 'rating': '4.6', 'reviews': '80'},
    {'image': 'assets/images/cleaning_provider.jpg', 'name': 'Clean Sweep', 'rating': '4.5', 'reviews': '110'},
    {'image': 'assets/images/Construction_provider.jpg', 'name': 'Build Master', 'rating': '4.8', 'reviews': '130'},
    {'image': 'assets/images/Architects_provider.jpg', 'name': 'Design Innovators', 'rating': '4.9', 'reviews': '100'},
    {'image': 'assets/images/Daniels_Design.jpg', 'name': 'Daniels Interior', 'rating': '4.7', 'reviews': '75'},
    {'image': 'assets/images/Furniture_provider.jpg', 'name': 'Custom Furniture', 'rating': '4.6', 'reviews': '60'},
    {'image': 'assets/images/tiler_provider.jpg', 'name': 'Tile Experts', 'rating': '4.5', 'reviews': '90'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Popular Services', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8, // Adjust as needed to fit content
        ),
        itemCount: popularServices.length,
        itemBuilder: (context, index) {
          final service = popularServices[index];
          return _buildPopularServiceGridItem(context, service);
        },
      ),
    );
  }

  Widget _buildPopularServiceGridItem(BuildContext context, Map<String, String> service) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Ensures image corners are rounded
      child: InkWell(
        onTap: () {
          // You can navigate to a ServiceDetailScreen here
          // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailScreen(serviceName: service['name']!)));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${service['name']}')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                service['image']!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${service['rating']!} (${service['reviews']} reviews)',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}