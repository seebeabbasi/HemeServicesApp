
import 'package:flutter/material.dart';

class HomeConstructionScreen extends StatefulWidget {
  final String? initialSearchQuery;

  const HomeConstructionScreen({super.key, this.initialSearchQuery});

  @override
  State<HomeConstructionScreen> createState() => _HomeConstructionScreenState();
}

class _HomeConstructionScreenState extends State<HomeConstructionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Construction',
      'description': 'Complete home and commercial construction services.',
      'image': 'assets/images/Construction.jpg', // Use image name provided
      'providerName': 'James', // Placeholder provider
      'rating': '4.6 (125 jobs)',
      'hourlyRate': 'PKR 350/hr',
      'providerImage': 'assets/images/Construction_provider.jpg', // Placeholder provider image
    },
    {
      'title': 'Architects',
      'description': 'Creative architectural designs and site planning.',
      'image': 'assets/images/Architects.jpg', // Use image name provided
      'providerName': 'Mikle', // Placeholder provider
      'rating': '4.6 (100 jobs)',
      'hourlyRate': 'PKR 450/hr',
      'providerImage': 'assets/images/Architects_provider.jpg', // Placeholder provider image
    },
    {
      'title': 'Interior Design',
      'description': 'Modern and elegant home/office interiors.',
      'image': 'assets/images/Interior.jpg', // Use image name provided
      'providerName': 'John', // As per your specific request in the image
      'rating': '2.5 (200 jobs)', // As per image
      'hourlyRate': 'PKR 250/hr',
      'providerImage': 'assets/images/Daniels_Design.jpg', // Specific painter image (if it's Ali's pic)
    },
    {
      'title': 'Furniture', // Added as per Image 2
      'description': 'Custom furniture design and installations.',
      'image': 'assets/images/Furniture.jpg', // Assuming you have this image
      'providerName': 'Jackson',
      'rating': '4.5(90 jobs)',
      'hourlyRate': 'PKR 310/hr',
      'providerImage': 'assets/images/Furniture_provider.jpg',
    },
    {
      'title': 'Tile Work',
      'description': 'Floor and wall tiling for kitchens, bathrooms, and more.',
      'image': 'assets/images/tiling.jpg',
      'providerName': 'Sohail Tiles .',
      'rating': '4.4 (60 jobs)',
      'hourlyRate': 'PKR 400/hr',
      'providerImage': 'assets/images/tiler_provider.jpg',
    },
  ];

  List<Map<String, dynamic>> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _filteredServices = _allServices;
    if (widget.initialSearchQuery != null) {
      _searchController.text = widget.initialSearchQuery!;
      _filterServices(widget.initialSearchQuery!);
    }
  }

  void _filterServices(String query) {
    setState(() {
      _filteredServices = _allServices
          .where((service) => service['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for services...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
            onChanged: _filterServices,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredServices.length,
            itemBuilder: (context, index) {
              final service = _filteredServices[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConstructionDetailScreen(
                        serviceCategory: service['title'],
                        providerName: service['providerName'],
                        rating: service['rating'],
                        hourlyRate: service['hourlyRate'],
                        providerImage: service['providerImage'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.asset(
                          service['image'],
                          width: 125,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['title'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              // FIX: Make the description text responsive
                              Text(
                                service['description'],
                                style: const TextStyle(color: Colors.grey,
                                  fontSize: 14,),
                                softWrap: true, // Allow text to wrap
                                overflow: TextOverflow.ellipsis, // Add ellipsis if it still overflows after wrapping
                                maxLines: 3, // Limit to a maximum of 3 lines to control height
                              ),
                            ],
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
    );
  }
}

class ConstructionDetailScreen extends StatefulWidget {
  final String serviceCategory;
  final String providerName;
  final String rating;
  final String hourlyRate;
  final String providerImage;


  static final Set<String> bookedServices = {};

  const ConstructionDetailScreen({
    super.key,
    required this.serviceCategory,
    required this.providerName,
    required this.rating,
    required this.hourlyRate,
    required this.providerImage,
  });

  @override
  State<ConstructionDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ConstructionDetailScreen> {
  bool get isBooked => ConstructionDetailScreen.bookedServices.contains(widget.providerName);

  void _bookService() {
    if (!isBooked) {
      setState(() {
        ConstructionDetailScreen.bookedServices.add(widget.providerName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.providerName} for ${widget.serviceCategory} booked successfully!')),
      );
      // In a real app, you might navigate to a confirmation page here
      // Or to the bookings screen:
      // Navigator.pushNamed(context, '/bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.providerImage,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 150, color: Colors.grey);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.providerName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.rating,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.hourlyRate,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isBooked ? null : _bookService,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isBooked ? 'Already Booked' : 'Book',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}