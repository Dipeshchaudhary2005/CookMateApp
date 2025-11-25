import 'package:flutter/material.dart';

class FavoriteChefPage extends StatelessWidget {
  const FavoriteChefPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorite Chefs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChefCard(
            'Chef John Ray',
            'Italian Cuisine',
            '4.8',
            '150+ bookings',
            'Resource/chef.png',
          ),
          _buildChefCard(
            'Ms. Lani',
            'Asian Fusion',
            '4.9',
            '200+ bookings',
            'Resource/chef.png',
          ),
          _buildChefCard(
            'Kevin Torio',
            'French Cuisine',
            '4.7',
            '120+ bookings',
            'Resource/chef.png',
          ),
          _buildChefCard(
            'Ron Shem',
            'Mediterranean',
            '4.8',
            '180+ bookings',
            'Resource/chef.png',
          ),
        ],
      ),
    );
  }

  Widget _buildChefCard(
    String name,
    String specialty,
    String rating,
    String bookings,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' $rating', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 12),
                    const Icon(Icons.bookmark, color: Colors.grey, size: 16),
                    Text(' $bookings', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
