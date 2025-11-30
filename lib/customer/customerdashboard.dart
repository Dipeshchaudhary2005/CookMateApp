import 'package:cookmate/backend/model/chefpost.dart';
import 'package:cookmate/backend/services/fetch_services.dart';
import 'package:cookmate/core/helper.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredPosts = [];
  static List<Map<String, dynamic>> favoritePosts = [];
  late Future<List<ChefPost>?> chefPostsFuture;
  ChefPost? selectedPost;
  // Sample chef posts data
  List<Map<String, dynamic>> chefPosts = [
    {
      'chefName': 'Ram Bhatta',
      'chefImage': 'Resource/chef.png',
      'specialty': 'Italian Cuisine',
      'experience': '4 Years',
      'rating': 4.8,
      'cuisineTitle': 'Italian Pasta Carbonara',
      'cuisineImage': 'Resource/chef.png',
      'description':
          'Authentic Italian pasta with creamy carbonara sauce, pancetta, and fresh parmesan cheese.',
      'likes': 156,
      'comments': 45,
      'isLiked': false,
      'price': 'NPR 650/person',
      'isFavorite': false,
      'commentList': [
        {
          'user': 'John Doe',
          'comment': 'Looks delicious! 😋',
          'time': '2 hours ago',
        },
        {
          'user': 'Sarah Smith',
          'comment': 'I tried this last week, amazing!',
          'time': '1 day ago',
        },
      ],
    },
    {
      'chefName': 'Sita Lama',
      'chefImage': 'Resource/chef.png',
      'specialty': 'Nepali Cuisine',
      'experience': '6 Years',
      'rating': 4.9,
      'cuisineTitle': 'Traditional Thakali Set',
      'cuisineImage': 'Resource/chef.png',
      'description':
          'Complete Thakali set with dal, bhat, tarkari, achar, and papad. Authentic taste from the mountains.',
      'likes': 234,
      'comments': 67,
      'isLiked': false,
      'price': 'NPR 550/person',
      'isFavorite': false,
      'commentList': [
        {
          'user': 'Mike Johnson',
          'comment': 'Best Thakali set in town!',
          'time': '3 hours ago',
        },
      ],
    },
    {
      'chefName': 'Rajesh Tharu',
      'chefImage': 'Resource/chef.png',
      'specialty': 'Asian Fusion',
      'experience': '5 Years',
      'rating': 4.7,
      'cuisineTitle': 'Special Momo Platter',
      'cuisineImage': 'Resource/chef.png',
      'description':
          'Assorted momo platter with chicken, buff, and veg momos served with special chutney.',
      'likes': 189,
      'comments': 52,
      'isLiked': false,
      'price': 'NPR 450/dozen',
      'isFavorite': false,
      'commentList': [
        {
          'user': 'Emma Wilson',
          'comment': 'Perfect for parties!',
          'time': '5 hours ago',
        },
        {
          'user': 'David Brown',
          'comment': 'The chutney is incredible 🔥',
          'time': '1 day ago',
        },
      ],
    },
    {
      'chefName': 'Chef Marlon',
      'chefImage': 'Resource/chef.png',
      'specialty': 'Mediterranean',
      'experience': '7 Years',
      'rating': 4.9,
      'cuisineTitle': 'Wedding Feast Special',
      'cuisineImage': 'Resource/chef.png',
      'description':
          '5-course wedding menu with appetizers, soup, main course, dessert, and beverages.',
      'likes': 312,
      'comments': 98,
      'isLiked': false,
      'price': 'NPR 1200/person',
      'isFavorite': false,
      'commentList': [
        {
          'user': 'Lisa Anderson',
          'comment': 'Booked for my wedding! Can\'t wait!',
          'time': '30 mins ago',
        },
        {
          'user': 'Robert Taylor',
          'comment': 'Outstanding service and taste',
          'time': '2 days ago',
        },
        {
          'user': 'Maria Garcia',
          'comment': 'Worth every penny! 💯',
          'time': '3 days ago',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredPosts = chefPosts;
    chefPostsFuture = FetchServices.getRecentPosts(context, 0);
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPosts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPosts = chefPosts;
      } else {
        filteredPosts = chefPosts.where((post) {
          return post['chefName'].toLowerCase().contains(query) ||
              post['cuisineTitle'].toLowerCase().contains(query) ||
              post['specialty'].toLowerCase().contains(query) ||
              post['description'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      filteredPosts[index]['isFavorite'] = !filteredPosts[index]['isFavorite'];

      // Update original list
      int originalIndex = chefPosts.indexWhere(
        (post) => post['cuisineTitle'] == filteredPosts[index]['cuisineTitle'],
      );
      if (originalIndex != -1) {
        chefPosts[originalIndex]['isFavorite'] =
            filteredPosts[index]['isFavorite'];
      }

      // Update favorites list
      if (filteredPosts[index]['isFavorite']) {
        if (!favoritePosts.any(
          (post) =>
              post['cuisineTitle'] == filteredPosts[index]['cuisineTitle'],
        )) {
          favoritePosts.add(filteredPosts[index]);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        favoritePosts.removeWhere(
          (post) =>
              post['cuisineTitle'] == filteredPosts[index]['cuisineTitle'],
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }
  void refreshPage() async {
    final newFuture = FetchServices.getRecentPosts(context, 0);
    setState(() {
      chefPostsFuture = newFuture;
    });
  }
  void _toggleLike(ChefPost post) async {
    bool? liked = await FetchServices.likePost(context, post.id!);
    if (liked == null) return;
    setState(() {
      post.liked = liked;
    });
    refreshPage();
  }

  void _addComment(String postId, String comment) async {
    bool success = await FetchServices.addComment(context, postId, comment);
    if (success){
      if (!mounted) return;
      final updatedPost = await FetchServices.getPostById(context, postId);
      setState(() async {
        selectedPost = updatedPost;
      });
    };
  }

  void _showCommentsDialog(String postId) async {
    final TextEditingController commentController = TextEditingController();
    selectedPost = await FetchServices.getPostById(context, postId);
    if (selectedPost == null) return;
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments (${selectedPost!.commentCount})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Comments List
                Expanded(
                  child: selectedPost!.comments!.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Be the first to comment!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: selectedPost!.comments!.length,
                          itemBuilder: (context, index) {
                            final comment = selectedPost!.comments![index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: const Color(0xFFB8E6B8),
                                    child: Image.network(
                                      comment.userPic!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.restaurant,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.userName ?? "No name",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              comment.updatedAt ?? "No time",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment.body ?? "No data",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Comment Input
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFB8E6B8),
                          child: Icon(Icons.person, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              setModalState(() {
                                _addComment(selectedPost!.id!, commentController.text);
                              });
                              commentController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF8BC34A),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFB8E6B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPostDetail(ChefPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Cuisine Image
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.network(
                    post.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cuisine Title
                      Text(
                        post.title!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8BC34A).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "PRICING", // TODO
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8BC34A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Likes and Comments
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text('${post.likeCount} likes'),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showCommentsDialog(post.id!);
                            },
                            child: const Icon(
                              Icons.comment,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showCommentsDialog(post.id!);
                            },
                            child: Text('${post.commentCount} comments'),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      // Chef Information
                      const Text(
                        'About the Chef',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                post.chef!.urlToImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person, size: 30);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.chef!.fullName!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  post.chef!.speciality!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('${post.chef!.rating}'),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.work,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(post.chef!.experience!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Book Now Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingPage(),
                              ),
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
                            'Book This Chef',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              Text(
                'Your Location',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Novaliches, QC',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
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
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for chefs or cuisines...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Featured Chef Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingPage(),
                      ),
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
                const SizedBox(height: 24),

                // Chef Posts Section
                const Text(
                  'Discover Chef Posts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<ChefPost>?>(
                  future: chefPostsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return buildPostCard(snapshot.data![index], index);
                          },
                        );
                      }
                      else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try searching with different keywords',
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
                    }
                    else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
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
                // Favorites - Navigate to Favorite Chef Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FavoriteChefPage(favoritePosts: favoritePosts),
                  ),
                );
                break;
              case 4:
                // Profile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerProfilePage(),
                  ),
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Summary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget buildPostCard(ChefPost post, int index){
    return GestureDetector(
      onTap: () => _showPostDetail(post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chef Header
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        post.chef!.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 20);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.chef!.fullName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${post.chef!.speciality}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${post.chef!.rating}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      post.liked!
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: post.liked!
                          ? const Color(0xFF8BC34A)
                          : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(index),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            // Cuisine Image
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                post.urlToImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.restaurant, size: 60, color: Colors.grey),
                  );
                },
              ),
            ),
            // Post Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.description!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleLike(post),
                        child: Icon(
                          post.favorite!
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: post.favorite! ? Colors.red : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likeCount}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => _showCommentsDialog(post.id!),
                        child: const Icon(
                          Icons.comment_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentCount}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8BC34A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          //TODO
                          'PRICE TODO',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
