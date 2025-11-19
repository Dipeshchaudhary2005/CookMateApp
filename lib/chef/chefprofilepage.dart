import 'package:flutter/material.dart';

class ChefProfilePage extends StatelessWidget {
  const ChefProfilePage({super.key});

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
          'Chef Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3D9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/chef_ram.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF8BC34A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ram Bhatta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Italian Cuisine Specialist',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('4.8', Icons.star, 'Rating'),
                        _buildStatItem('150+', Icons.bookmark, 'Bookings'),
                        _buildStatItem('4', Icons.work, 'Years Exp'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Specialties
              _buildSectionCard(
                'Specialties',
                Column(
                  children: [
                    _buildChipList([
                      'Italian Cuisine',
                      'Pasta',
                      'Pizza',
                      'Risotto',
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Experience Info
              _buildSectionCard(
                '4 Upcoming Jobs',
                Column(
                  children: [
                    _buildJobItem('Wedding Event', 'March 15, 2025'),
                    _buildJobItem('Birthday Party', 'March 18, 2025'),
                    _buildJobItem('Corporate Event', 'March 20, 2025'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Availability
              _buildSectionCard(
                'Availability Settings',
                Column(
                  children: [
                    _buildAvailabilityToggle('Accept New Bookings', true),
                    _buildAvailabilityToggle('Weekend Availability', true),
                    _buildAvailabilityToggle('Private Events', true),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Payment Methods
              _buildSectionCard(
                'Payment Methods',
                Column(
                  children: [
                    _buildPaymentMethod('Bank Transfer', Icons.account_balance),
                    _buildPaymentMethod('Cash', Icons.money),
                    _buildPaymentMethod('Digital Wallet', Icons.wallet),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildChipList(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Chip(
          label: Text(item),
          backgroundColor: const Color(0xFFB8E6B8),
          labelStyle: const TextStyle(fontSize: 12),
        );
      }).toList(),
    );
  }

  Widget _buildJobItem(String title, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Switch(
            value: value,
            onChanged: (val) {},
            activeThumbColor: const Color(0xFF8BC34A),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
