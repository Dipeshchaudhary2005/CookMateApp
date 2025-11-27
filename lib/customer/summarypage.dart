import 'package:flutter/material.dart';
import 'ratingpage.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String selectedEvent = 'Engagement Function';
  bool showAppetizers = false;
  bool showMainCourse = false;
  bool showSidesDesserts = false;
  bool showBeverages = false;

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
          'Summary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Booking'),
                  content: const Text(
                    'Are you sure you want to confirm this booking?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking confirmed successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Navigate to rating page after 1 second
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RatingPage(),
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8BC34A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date of Event Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.purple),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '24-02-28',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '8:00 AM - 8:00 AM',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Type of Event
              const Text(
                'Type of Event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.celebration, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedEvent,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items:
                            ['Engagement Function', 'Birthday Party', 'Wedding']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            setState(() => selectedEvent = val!),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Section
              const Text(
                'Menu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Appetizers
              _buildMenuSection(
                'Appetizers',
                showAppetizers,
                () => setState(() => showAppetizers = !showAppetizers),
              ),
              const SizedBox(height: 12),

              // Main Courses
              _buildMenuSection(
                'Main Courses',
                showMainCourse,
                () => setState(() => showMainCourse = !showMainCourse),
              ),
              const SizedBox(height: 12),

              // Sides & Desserts
              _buildMenuSection(
                'Sides & Desserts',
                showSidesDesserts,
                () => setState(() => showSidesDesserts = !showSidesDesserts),
              ),
              const SizedBox(height: 12),

              // Beverages
              _buildMenuSection(
                'Beverages',
                showBeverages,
                () => setState(() => showBeverages = !showBeverages),
              ),
              const SizedBox(height: 20),

              // Chef Details
              const Text(
                'Chef Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'Resource/chef.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 30);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ram Bhatta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Italian',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '4 Years of Experience',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Speciality: Italian Cuisine',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, bool isExpanded, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        onTap: onTap,
      ),
    );
  }
}
