import 'package:flutter/material.dart';
import 'bookingpage.dart';
import 'favoritechefpage.dart';
import 'customerprofilepage.dart';
import 'summarypage.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFB8E6B8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Colors.red, size: 20),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Location',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Novaliches, QC',
                style: TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.purple),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Featured Chef Card - CLICKABLE TO BOOKING PAGE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8E6B8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'Resource/chef.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.restaurant, size: 30);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHEF MARLON',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'discount 30% on\nspecialized cuisine',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Popular Cuisine Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Cuisine by Top Chef',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Cuisine Grid - EACH CARD CLICKABLE TO BOOKING PAGE
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
                children: [
                  _buildCuisineCard('Chef John Ray', 'Resource/chef.png'),
                  _buildCuisineCard('Kalagar', 'Resource/chef.png'),
                  _buildCuisineCard('Meat Specialist', 'Resource/chef.png'),
                  _buildCuisineCard('Ms. Lani', 'Resource/chef.png'),
                  _buildCuisineCard('Kevin Torio', 'Resource/chef.png'),
                  _buildCuisineCard('Ron Shem', 'Resource/chef.png'),
                  _buildCuisineCard('Morris Carl', 'Resource/chef.png'),
                  _buildCuisineCard('Joshua', 'Resource/chef.png'),
                  _buildCuisineCard('Dessert Chef', 'Resource/chef.png'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate based on selected tab
          switch (index) {
            case 0:
            // Home - Already on this page
              break;
            case 1:
            // Summary - Navigate to Summary Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SummaryPage()),
              );
              break;
            case 2:
            // Calendar - Navigate to Booking Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingPage()),
              );
              break;
            case 3:
            // Favorites
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteChefPage()),
              );
              break;
            case 4:
            // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCuisineCard(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to booking page when chef card is clicked
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingPage()),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.restaurant, size: 40);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}