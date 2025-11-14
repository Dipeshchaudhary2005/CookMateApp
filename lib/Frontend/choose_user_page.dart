import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCF0D6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildLogo(),
            const SizedBox(height: 16),
            const Text(
              'CookMate',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your own Kitchen Companion',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFFFB347),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'Choose :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(userType: 'Customer'),
                  ),
                );
              },
              child: _buildUserCard(
                icon: Icons.shopping_cart,
                title: "I'm a Customer",
                subtitle: "Browse recipes, create meal plans,\nand order ingredients",
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(userType: 'Chef'),
                  ),
                );
              },
              child: _buildUserCard(
                icon: Icons.restaurant,
                title: "I'm a Chef",
                subtitle: "Share your creations, manage your\nkitchen",
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Power by CookMate Inc',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Stack(
          children: [
            Positioned(
              left: 14,
              top: 18,
              child: Container(
                width: 52,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 25,
              child: Container(
                width: 40,
                height: 7,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 20,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB347),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.6),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}