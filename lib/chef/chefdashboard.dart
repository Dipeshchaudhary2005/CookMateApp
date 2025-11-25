import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'bookeddetailedpage.dart';
import 'chefprofilepage.dart';
import 'managemenuprice.dart';
import 'calendarupdate.dart';

class ChefDashboard extends StatefulWidget {
  const ChefDashboard({super.key});

  @override
  State<ChefDashboard> createState() => _ChefDashboardState();
}

class _ChefDashboardState extends State<ChefDashboard> {
  // Sample booking data for status card
  int pendingCount = 3;
  int confirmedCount = 2;
  int completedCount = 1;

  // Search controller and filtered list
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCuisines = [];
  bool isSearching = false;

  // Sample posted cuisine images
  List<Map<String, dynamic>> postedCuisines = [
    {
      'image': 'Resource/chef.png',
      'title': 'Italian Pasta Carbonara',
      'likes': 45,
      'comments': 12,
      'date': '2 days ago',
    },
    {
      'image': 'Resource/chef.png',
      'title': 'Nepalese Thakali Set',
      'likes': 67,
      'comments': 23,
      'date': '5 days ago',
    },
    {
      'image': 'Resource/chef.png',
      'title': 'Special Momo Platter',
      'likes': 89,
      'comments': 34,
      'date': '1 week ago',
    },
    {
      'image': 'Resource/chef.png',
      'title': 'Wedding Feast Menu',
      'likes': 102,
      'comments': 45,
      'date': '2 weeks ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredCuisines = postedCuisines;
    _searchController.addListener(_filterCuisines);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCuisines() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCuisines = postedCuisines;
        isSearching = false;
      } else {
        isSearching = true;
        filteredCuisines = postedCuisines.where((cuisine) {
          return cuisine['title'].toLowerCase().contains(query) ||
              cuisine['date'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        filteredCuisines = postedCuisines;
      }
    });
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Show dialog to choose camera or gallery
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Cuisine'),
        content: const Text('Choose image source:'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        // Show post creation dialog
        _showPostCreationDialog(image.path);
      }
    }
  }

  void _showPostCreationDialog(String imagePath) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Post',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Cuisine Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty) {
                          setState(() {
                            postedCuisines.insert(0, {
                              'image': imagePath,
                              'title': titleController.text,
                              'likes': 0,
                              'comments': 0,
                              'date': 'Just now',
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post created successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                      ),
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8E6B8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF8BC34A)),
          ),
        ),
        title: isSearching
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search your posts...',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              icon: const Icon(Icons.search, color: Colors.grey, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
            ),
          ),
        )
            : Row(
          children: [
            Icon(Icons.location_on, color: Colors.grey[700], size: 20),
            const SizedBox(width: 4),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ram Bhatta',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Notification functionality placeholder
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3D9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusItem('$pendingCount', 'Pending'),
                        _buildStatusItem('$confirmedCount', 'Confirmed'),
                        _buildStatusItem('$completedCount', 'Completed'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // My Posted Cuisines Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSearching
                        ? 'Search Results (${filteredCuisines.length})'
                        : 'My Posted Cuisines',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (!isSearching)
                    TextButton(
                      onPressed: () {
                        // View all posts
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View all posts coming soon!')),
                        );
                      },
                      child: const Text('View All'),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Posted Cuisines Grid
              filteredCuisines.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isSearching ? 'No posts found' : 'No posts yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSearching
                            ? 'Try searching with different keywords'
                            : 'Start posting your cuisines',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredCuisines.length,
                itemBuilder: (context, index) {
                  return _buildCuisineCard(filteredCuisines[index]);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildStatusItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCuisineCard(Map<String, dynamic> cuisine) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                cuisine['image'],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.restaurant, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Flexible(
                    child: Text(
                      cuisine['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stats and Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Likes and Comments Row
                      Row(
                        children: [
                          const Icon(Icons.favorite, size: 14, color: Colors.red),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${cuisine['likes']}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.comment, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${cuisine['comments']}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Date
                      Text(
                        cuisine['date'],
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF8BC34A),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          // Bookings button tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookedDetailsPage(),
            ),
          );
        } else if (index == 2) {
          // Post button tapped
          _pickAndUploadImage(context);
        } else if (index == 3) {
          // Calendar button tapped - Navigate to Calendar
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CalendarPage(),
            ),
          );
        } else if (index == 4) {
          // Profile button tapped
          _showProfileMenu(context);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 32),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Profile Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF8BC34A)),
              title: const Text('My Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChefProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Color(0xFF8BC34A)),
              title: const Text('Manage Menu & Pricing'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageMenuPricePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_available, color: Color(0xFF8BC34A)),
              title: const Text('Manage Availability'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF8BC34A)),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings page coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[700]),
            const SizedBox(width: 12),
            const Text('Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Close the dialog
              Navigator.pop(context);

              // Show logout confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Logged out successfully'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              // Navigate back to login/home screen after a short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                // Pop until reaching the root (login screen)
                // Replace this with your actual login route
                Navigator.of(context).popUntil((route) => route.isFirst);

                // Alternative: Navigate to a specific login page
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => const LoginPage()),
                //   (route) => false,
                // );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}