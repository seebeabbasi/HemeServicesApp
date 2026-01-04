import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'OrderSummary.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final String providerName;

  const BookingScreen({super.key, required this.service, required this.providerName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedApartmentSize = '';
  String selectedArea = '';
  DateTime selectedDate = DateTime.now(); // Initialize with current date
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController areaController = TextEditingController();

  final List<String> apartmentSizes = [
    '1 BHK', '2 BHK', '2.5 BHK', '3 BHK', '3.5 BHK', '4 BHK', '4.5 BHK'
  ];

  @override
  void initState() {
    super.initState();
    // Set a default selected date to match the image (July 4, 2025)
    selectedDate = DateTime(2025, 7, 4);
    selectedApartmentSize = apartmentSizes.first; // Default selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(widget.service['image_path']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Provider Name - Added to fix the issue
            Text(
              widget.providerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Apartment Size Selection
            const Text(
              'Apartment Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: apartmentSizes.map((size) {
                final isSelected = selectedApartmentSize == size;
                return GestureDetector(
                  onTap: () => setState(() => selectedApartmentSize = size),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Area Input
            const Text(
              'Area in Sqft',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number, // Ensure numeric input
              decoration: InputDecoration(
                hintText: 'Area in square fit',
                suffixIcon: const Icon(Icons.add),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Date Selection
            const Text(
              'Pick a date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dynamic date tiles for a few days around the selected date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final DateTime date = selectedDate.subtract(Duration(days: selectedDate.weekday - 1)).add(Duration(days: index));
                final String day = date.day.toString();
                final String weekday = DateFormat('EEE').format(date); // Mon, Tue, etc.
                final bool isSelected = date.day == selectedDate.day && date.month == selectedDate.month && date.year == selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: _buildDateTile(day, weekday, isSelected: isSelected),
                );
              }),
            ),
            const SizedBox(height: 30),

            // Time Selection
            const Text(
              'Pick a Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              'Select time: ${selectedTime.format(context)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    setState(() => selectedTime = time);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SELECT TIME',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Continue Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the OrderSummaryScreen with all the selected data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSummaryScreen(
                        service: widget.service,
                        // FIX: Pass the providerName inside a map to satisfy the 'providers' parameter.
                        providers: {'name': widget.providerName},
                        providerName: widget.providerName,
                        apartmentSize: selectedApartmentSize,
                        area: selectedArea,
                        selectedDate: selectedDate,
                        selectedTime: selectedTime,
                        imageUrl: widget.service['image_path'],
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price on next screen',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTile(String day, String weekday, {bool isSelected = false}) {
    return Container(
      width: 48,
      height: 70,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weekday,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}