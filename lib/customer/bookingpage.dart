import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedEvent = 'Engagement Function';
  String selectedDate = '2025-02-28';
  String selectedTime = '8:00 AM - 8:00 AM';
  String? selectedPackage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8E6B8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book a Chef',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type of Event
              const Text(
                'Type of Event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedEvent,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['Engagement Function', 'Birthday Party', 'Wedding']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedEvent = val!),
                ),
              ),
              const SizedBox(height: 20),

              // Select Date
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedDate,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['2025-02-28', '2025-03-01', '2025-03-02']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedDate = val!),
                ),
              ),
              const SizedBox(height: 20),

              // Select Hours
              const Text(
                'Select Hours',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedTime,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: [
                    '8:00 AM - 8:00 AM',
                    '9:00 AM - 12:00 PM',
                    '1:00 PM - 5:00 PM'
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => selectedTime = val!),
                ),
              ),
              const SizedBox(height: 20),

              // Select Package
              const Text(
                'Select Package',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPackageCard(
                '2-Course Dinner',
                'Good - 650 Combo',
                'Dine in 2-course/guest',
                const Color(0xFFFFB3D9),
              ),
              const SizedBox(height: 12),
              _buildPackageCard(
                'Private Cooking',
                'Opens Morning',
                'Very Good 4-course/guest',
                const Color(0xFFFFB3D9),
              ),
              const SizedBox(height: 12),
              _buildPackageCard(
                'Custom Menu',
                'Unspecified contact',
                'Dine out booking/guest',
                Colors.white,
              ),
              const SizedBox(height: 30),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SummaryPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(String title, String price, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(fontSize: 14)),
                Text(description, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.help_outline, color: Colors.grey),
        ],
      ),
    );
  }
}

// Placeholder for SummaryPage navigation
class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Summary Page')));
  }
}