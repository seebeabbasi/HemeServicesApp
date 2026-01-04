import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AccountScreen.dart';
import 'HomeScreen.dart';
import 'OrderSummary.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NotificationScreen.dart';
import 'bookings_screen.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? 'John Smith';
    final String userEmail = user?.email ?? 'johnsmith@gmail.com';

    return Scaffold(
      backgroundColor: Colors.black, // Dark background as per theme
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    backgroundColor: Colors.grey[800],
                    child: user?.photoURL == null
                        ? Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            _buildOptionTile(
              context,
              icon: Icons.person,
              title: 'My Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              showEditIcon: true, // As seen in the image
            ),
            _buildOptionTile(
              context,
              icon: Icons.favorite,
              title: 'My Favourites',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeServiceScreen()), // Navigate to a screen showing favorite services
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.calendar_today,
              title: 'My bookings',
              onTap: () {
                // FIX: Pass the required 'service' and 'providerName' arguments.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingsScreen()
                ),
                );
              },
    ),
            _buildOptionTile(
              context,
              icon: Icons.attach_money,
              title: 'Refer and earn',
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
            _buildOptionTile(
              context,
              icon: Icons.mail,
              title: 'Contact Us',
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'ha2742285@gmail.com', // Replace with your valid Gmail
                  query: _encodeQueryParameters(<String, String>{
                    'subject': 'Contact Us Query',
                    'body': 'Hi Team,\n\nI would like to...',
                  }),
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email client')),
                  );
                }
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.help_center,
              title: 'Help Center',
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'ha2742285@gmail.com', // Replace with your valid Gmail
                  query: _encodeQueryParameters(<String, String>{
                    'subject': 'Help Center Query',
                    'body': 'Hi Support Team,\n\nI need help with...',
                  }),
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email client')),
                  );
                }
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.abc,
              title: 'Offers And Coupons',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderSummaryScreen(
                      service: {"name": "Special Discount Service", "price": 1120},
                      providers: {"name": "Coupon Provider"},
                      apartmentSize: "2BHK",
                      area: "1200",
                      selectedDate: DateTime.now(),
                      selectedTime: TimeOfDay.now(),
                      imageUrl: "assets/images/discount.jpg", // put a valid image from assets
                      providerName: "Coupon Provider",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool showEditIcon = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: showEditIcon
              ? IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: onTap, // Edit icon also triggers the tap
          )
              : null,
          onTap: onTap,
        ),
        Divider(color: Colors.grey.withOpacity(0.3), height: 1), // Separator
      ],
    );
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}