import 'dart:io';

import 'package:cookmate/backend/model/chefpost.dart';
import 'package:cookmate/backend/services/post_services.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'bookeddetailedpage.dart';
import 'chefprofilepage.dart';
import 'managemenuprice.dart';
import 'calendarupdate.dart';
import 'notification.dart'; // Import notification page

class ChefDashboard extends StatefulWidget {
  const ChefDashboard({super.key});

  @override
  State<ChefDashboard> createState() => _ChefDashboardState();
}

class _ChefDashboardState extends State<ChefDashboard> {
  int pendingCount = 3;
  int confirmedCount = 2;
  int completedCount = 1;
  int unreadNotifications = 5; // Track unread notifications

  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  late Future<List<ChefPost>?> postsFuture;
  late List<ChefPost> posts;
  late List<ChefPost> filteredPosts;

  @override
  void initState() {
    super.initState();
    postsFuture = PostServices.getPostOfChef(
      context,
      StaticClass.currentUser!.uid!,
    );
    _searchController.addListener(_filterCuisines);
  }

  @override
  void dispose() {
    _searchController.dispose();
    filteredPosts = posts;
    super.dispose();
  }

  void _filterCuisines() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPosts = posts;
        isSearching = false;
      } else {
        isSearching = true;
        filteredPosts = posts.where((post) {
          return post.title!.toLowerCase().contains(query) ||
              post.createdAt!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        filteredPosts = posts;
      }
    });
  }

  // Navigate to notification page
  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChefNotificationPage(),
      ),
    ).then((_) {
      // Reset unread count when returning from notifications
      setState(() {
        unreadNotifications = 0;
      });
    });
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

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
        _showPostCreationDialog(File(image.path));
      }
    }
  }

  void _showPostCreationDialog(File image) {
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
                      onPressed: () async {
                        if (titleController.text.isNotEmpty) {
                          final newPost = await PostServices.createPost(
                            context,
                            image,
                            titleController.text,
                            descriptionController.text,
                          );
                          if (newPost == null) return;
                          setState(() {
                            filteredPosts.add(newPost);
                          });
                          if (!context.mounted) return;
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        showDialog(
          context: context,
          builder: (context) => Helper.confirmLogOut(context),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFB8E6B8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: StaticClass.currentUser?.urlToImage != null ?
                        Image.network(StaticClass.currentUser!.urlToImage!, fit: BoxFit.cover,) :
                        Icon(Icons.person, color: Color(0xFF8BC34A)),
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
                  color: Colors.black.withValues(alpha: 0.1),
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
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20,
                ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StaticClass.currentUser!.fullName ?? "No name",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                color: Colors.black,
              ),
              onPressed: _toggleSearch,
            ),
            // Notification button with badge
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                  onPressed: _openNotifications,
                ),
                if (unreadNotifications > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadNotifications > 9 ? '9+' : '$unreadNotifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isSearching
                          ? 'Search Results (${filteredPosts.length})'
                          : 'My Posted Cuisines',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isSearching)
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('View all posts coming soon!'),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                FutureBuilder(
                  future: postsFuture,
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.done) {
                      if (snapShot.hasData) {
                        posts = snapShot.data!;
                        filteredPosts = posts;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            return _buildCuisineCard(filteredPosts[index]);
                          },
                        );
                      } else {
                        return Center(
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
                                  isSearching
                                      ? 'No posts found'
                                      : 'No posts yet',
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
                        );
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildStatusItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildCuisineCard(ChefPost post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              child: Image.network(
                post.urlToImage!,
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
                      post.title!,
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
                          const Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${post.likeCount}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.comment,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${post.commentCount}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Date
                      Text(
                        post.createdAt!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
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
            MaterialPageRoute(builder: (context) => const BookedDetailsPage()),
          );
        } else if (index == 2) {
          // Post button tapped
          _pickAndUploadImage(context);
        } else if (index == 3) {
          // Calendar button tapped - Navigate to Calendar
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CalendarPage()),
          );
        } else if (index == 4) {
          // Profile button tapped
          _showProfileMenu(context);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              leading: const Icon(
                Icons.restaurant_menu,
                color: Color(0xFF8BC34A),
              ),
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
              leading: const Icon(
                Icons.event_available,
                color: Color(0xFF8BC34A),
              ),
              title: const Text('Manage Availability'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
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
                Helper.confirmLogOut(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
