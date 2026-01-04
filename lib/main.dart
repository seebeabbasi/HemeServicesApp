import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'BookingScreen.dart';
import 'NotificationScreen.dart';
import 'booking_manager.dart'; // Import the BookingManager class
import 'bookings_screen.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'signup.dart';
import 'HomeScreen.dart';
import 'AccountScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AccountMainScreen.dart';
import 'PopularServiceScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Wrap the entire app with a ChangeNotifierProvider for BookingManager
    ChangeNotifierProvider(
      create: (context) => BookingManager(),
      child: const ProKitCloneApp(),
    ),
  );
}

class ProKitCloneApp extends StatelessWidget {
  const ProKitCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProKit Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF2C2C2C),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/full_apps': (context) => const FullAppsScreen(),
        '/home_service': (context) => const HomeServiceScreen(),
        // The BookingScreen no longer needs arguments since it gets data from the provider.
        '/bookings': (context) => const BookingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/Account': (context) => const AccountScreen(),
        '/popular_services': (context) => const PopularServicesScreen(),
      },
    );
  }
}

class FullAppsScreen extends StatefulWidget {
  const FullAppsScreen({super.key});

  @override
  State<FullAppsScreen> createState() => _FullAppsScreenState();
}

class _FullAppsScreenState extends State<FullAppsScreen> {
  int _selectedIndex = 0; // 0: Home, 1: Search, 2: Bookings, 3: Account (special handling)
  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const HomeServiceScreen(),
    // CORRECTED: Remove `const` and the empty arguments.
    // The BookingsScreen will now fetch its data from the provider.
    const BookingsScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Special handling for the 'Account' tab (index 3)
    // if (index == 3) {
    //   // Use addPostFrameCallback to ensure the context is valid after the current frame builds
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     // We use `context` from the `_FullAppsScreenState` which is a valid descendant of Scaffold.
    //     if (Scaffold.of(context).hasDrawer) {
    //       Scaffold.of(context).openDrawer(); // Open the drawer
    //     }
    //   });
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Consistent dark background
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Hamburger icon for drawer
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications), // Notification icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.black, // Consistent dark app bar
      ),
      // The actual drawer widget for the Scaffold
      drawer: Drawer(
        child: Container(
          color: Colors.black, // Background color of entire drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.orange
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.orange),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'User Name',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? 'user@example.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('My Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text('My Favourites', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeServiceScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text('Notification', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.book_online, color: Colors.white),
                title: const Text('My Bookings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _onItemTapped(2); // Navigate to My Bookings tab
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard, color: Colors.white),
                title: const Text('Refer and earn', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  const referralMessage =
                      'Hey! Check out this awesome app. Download now: https://my-new-project-56ef3.firebaseapp.com';

                  final Uri shareUri = Uri(
                    scheme: 'mailto',
                    queryParameters: {
                      'subject': 'Check out this app!',
                      'body': referralMessage,
                    },
                  );

                  if (await canLaunchUrl(shareUri)) {
                    await launchUrl(shareUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch share intent')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.white),
                title: const Text('Contact Us..? Help Center', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer

                  final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'User@gmail.com';

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Help & Support"),
                      content: Text(userEmail),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); // Close AlertDialog

                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'ha2742285@gmail.com', // Replace with your valid Gmail
                              query: _encodeQueryParameters(<String, String>{
                                'subject': 'Need Help & Support',
                                'body': 'Hi Support Team,\n\nI need help with...'
                              }),
                            );

                            if (await canLaunchUrl(emailLaunchUri)) {
                              await launchUrl(emailLaunchUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open Gmail')),
                              );
                            }
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context); // Close the drawer
                  await FirebaseAuth.instance.signOut();
                  // Ensure you navigate to a route that handles authentication
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Dark background for bottom nav
        selectedItemColor: Colors.orange, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeServiceScreen()),
                  ),
              decoration: InputDecoration(
                hintText: 'Search for services...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme
                    .of(context)
                    .cardColor,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Sale Banner
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D4AA), Color(0xFF00B894)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Akshaya Tritiya',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const Text(
                          'SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                          ),
                          child: const Text('SHOP NOW'),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '60%\nOFF',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'SPECIAL DISCOUNT',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Home Services Section
            _buildSectionHeader(context, "Home Services", () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeServiceScreen()),
                )),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildServiceCategory(context, Icons.build, 'Plumber'),
                _buildServiceCategory(
                    context, Icons.electric_bolt, 'Electrician'),
                _buildServiceCategory(context, Icons.format_paint, 'Painting'),
                _buildServiceCategory(context, Icons.carpenter, 'Carpenter'),
                _buildServiceCategory(
                    context, Icons.cleaning_services, 'Cleaning'),
              ],
            ),
            const SizedBox(height: 20),

            // Home Construction Section
            _buildSectionHeader(context, "Home Construction", () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeServiceScreen()),
                )),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildServiceCategory(
                    context, Icons.construction, 'Construction',
                    targetService: 'Plumber'),
                _buildServiceCategory(context, Icons.architecture, 'Architects',
                    targetService: 'Electrician'),
                _buildServiceCategory(
                    context, Icons.design_services, 'Interior Design',
                    targetService: 'Painting'),
                _buildServiceCategory(context, Icons.chair, 'Furniture',
                    targetService: 'Carpenter'),
                _buildServiceCategory(context, Icons.build, 'Tile Work',
                    targetService: 'Cleaning'), // Example, adjust as needed
              ],
            ),
            const SizedBox(height: 20),

            // Popular Services Section (Implemented based on image)
            _buildSectionHeader(context, "Popular Services", () {
              // Navigate to HomeServiceScreen or a specific "View All Popular Services" screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeServiceScreen()),
              );
            }),
            const SizedBox(height: 15),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Updated serviceName to match existing service titles for proper filtering
                  _buildPopularServiceCard(
                      context, 'assets/images/plumber_provider.jpg', 'Plumber'),
                  _buildPopularServiceCard(
                      context, 'assets/images/electrician_provider.jpg',
                      'Electrician'),
                  _buildPopularServiceCard(
                      context, 'assets/images/Ali_painter.jpg', 'Painting'),
                  _buildPopularServiceCard(
                      context, 'assets/images/cleaning_provider.jpg',
                      'Cleaning'),
                  _buildPopularServiceCard(
                      context, 'assets/images/Carpenter_provider.jpeg',
                      'Carpenter'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Renovate your home Section (Implemented based on image)
            _buildSectionHeader(context, "Renovate your home", () {
              // Navigate to HomeServiceScreen or a specific "View All Renovations" screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeServiceScreen()),
              );
            }),
            const SizedBox(height: 15),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRenovationCard(
                      context, 'assets/images/HomeInteriors.jpg',
                      'Home Interiors'),
                  _buildRenovationCard(
                      context, 'assets/images/ModularKitchen.jpg',
                      'Modular Kitchen'),
                  _buildRenovationCard(
                      context, 'assets/images/CommercialBuilding.jpg',
                      'Commercial Building'),
                  _buildRenovationCard(
                      context, 'assets/images/OfficeInterior.jpg',
                      'Office interior'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Renovate your home Section (Implemented based on image)
            _buildSectionHeader(context, "Combos And Subscriptions", () {
              // Navigate to HomeServiceScreen or a specific "View All Renovations" screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeServiceScreen()),
              );
            }),
            const SizedBox(height: 15),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCombosCard(
                      context, 'assets/images/PestControl.jpg', 'Pest Control'),
                  _buildCombosCard(
                      context, 'assets/images/FullHouseCleaning.jpg',
                      'Full House Cleaning'),
                  _buildCombosCard(context, 'assets/images/ModularKitchen.jpg',
                      'Kitchen & Bathroom Cleaning'),
                  // _buildRenovationCard(context, 'assets/images/OfficeInterior.jpg', 'Bathroom Cleaning'),
                ],
              ),
            ),
            const SizedBox(height: 80),
            // What Customers Say
            _buildSectionHeader(context, "What Our Customers Say", () {}),
            const SizedBox(height: 15),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildReviewCard(
                      "Marry Jaine", "Great service! Very professional."),
                  _buildReviewCard(
                      "John", "Highly satisfied. Will book again."),
                  _buildReviewCard("Robert Johnson", "Quick and clean. Nice!"),
                ],
              ),
            ),
            const SizedBox(height: 20),
// Add some bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String review, {String? imageUrl}) {
    return Container(
      width: 280,
      // Slightly wider to accommodate content
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Changed to white as per image
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Lighter shadow
            blurRadius: 6,
            offset: const Offset(0, 3), // Subtle shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Image Placeholder (replace with actual image loading)
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl == null ? const Icon(
                    Icons.person, color: Colors.grey) : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87, // Darker text color
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Star Rating
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        // Example: 4 filled, 1 border
                        color: Colors.orange,
                        size: 18,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: TextStyle(
              color: Colors.grey[700], // Darker grey for review text
              fontSize: 14,
            ),
            maxLines: 3, // Limit to 3 lines for brevity
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        TextButton(
          onPressed: onPressed,
          // Use the passed onPressed callback for navigation
          child: const Text(
            'View All',
            style: TextStyle(color: Colors.orange, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCategory(BuildContext context, IconData icon,
      String label, {String? targetService}) {
    return GestureDetector(
      onTap: () {
        // Corrected line: Use the 'query' variable, which holds the 'targetService' or 'label'
        final query = targetService ?? label;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeServiceScreen(initialSearchQuery: query),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Modified _buildPopularServiceCard to use Image.asset and be clickable
  Widget _buildPopularServiceCard(BuildContext context, String imagePath,
      String serviceName) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeServiceScreen(initialSearchQuery: serviceName),
            ),
          ),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                serviceName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

// The corrected _buildRenovationCard and _buildCombosCard methods

// New Widget for Renovate your home section
  Widget _buildRenovationCard(BuildContext context, String imagePath,
      String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingScreen(
                  service: {
                    'name': title, // Change 'title' to 'name'
                    'image_path': imagePath,
                    'price': '8000',
                  },
                  providerName: "John's Cleaning Services",
                ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

// New Widget for Combos And Subscriptions section
  Widget _buildCombosCard(BuildContext context, String imagePath,
      String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingScreen(
                  service: {
                    'name': title, // Change 'title' to 'name'
                    'image_path': imagePath,
                    'price': '8000',
                  },
                  providerName: "John's Cleaning Services",
                ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String imagePath;
  final String title;
  final String description;

  OnboardingContent({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> onboardingPages = [
    OnboardingContent(
      imagePath: 'assets/images/Home.jpg',
      title: 'Give your home a makeover',
      description:
      'The best services that you could find for your home, as we have everything that you are in need.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/Home1.jpg',
      title: 'Qualified Professionals',
      description:
      'Search From the list of Qualified Professionals around you as we bring the best one for you',
    ),
    OnboardingContent(
      imagePath: 'assets/images/Home2.jpg',
      title: 'Easy & Fast Services',
      description:
      'Book your services at your convenient time\nand enjoy the hassle-free process.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Preload all images for sharpness
    for (var content in onboardingPages) {
      precacheImage(AssetImage(content.imagePath), context);
    }

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return Image.asset(
                onboardingPages[index].imagePath,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high, // Ensures sharpness
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Text(
                      'Image Not Found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingPages.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    onboardingPages[_currentPage].title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    onboardingPages[_currentPage].description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  if (_currentPage == onboardingPages.length - 1)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
