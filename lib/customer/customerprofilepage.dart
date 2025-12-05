import 'package:cookmate/backend/services/user_services.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  Image _profileImage = StaticClass.currentUser!.urlToImage != null
      ? Image.network(StaticClass.currentUser!.urlToImage!, fit: BoxFit.cover)
      : StaticClass.noImage;
  final ImagePicker _picker = ImagePicker();

  // User data
  String userName = StaticClass.currentUser!.fullName ?? "Null";
  String userEmail = StaticClass.currentUser!.email ?? "Null";
  String userPhone = StaticClass.currentUser!.phoneNumber ?? "No Phone";
  String userAddress = StaticClass.currentUser!.userAddress ?? "No address";

  // Settings
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool pushNotifications = true;

  // Booking history data
  final List<Map<String, dynamic>> bookingHistory = [
    {
      'chefName': 'Chef Marlon',
      'eventType': 'Wedding',
      'date': '2024-03-15',
      'time': '4:00 PM - 8:00 PM',
      'status': 'Completed',
      'amount': 'NPR 15,000',
      'rating': 4.5,
    },
    {
      'chefName': 'Chef John Ray',
      'eventType': 'Birthday Party',
      'date': '2024-02-28',
      'time': '12:00 PM - 4:00 PM',
      'status': 'Completed',
      'amount': 'NPR 8,500',
      'rating': 5.0,
    },
    {
      'chefName': 'Ms. Lani',
      'eventType': 'Engagement Function',
      'date': '2024-04-20',
      'time': '8:00 PM - 12:00 AM',
      'status': 'Upcoming',
      'amount': 'NPR 12,000',
      'rating': null,
    },
  ];

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null && mounted) {
        final changed = await UserServices.updateProfilePic(
          context,
          File(pickedFile.path),
        );
        if (changed) {
          setState(() {
            _profileImage = StaticClass.currentUser!.urlToImage != null
                ? Image.network(
              StaticClass.currentUser!.urlToImage!,
              fit: BoxFit.cover,
            )
                : StaticClass.noImage;
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show image source dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF8BC34A)),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF8BC34A),
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Edit Profile Dialog
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);
    final phoneController = TextEditingController(text: userPhone);
    final addressController = TextEditingController(text: userAddress);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = userName != nameController.text
                  ? nameController.text
                  : null;
              final newEmail = userEmail != emailController.text
                  ? emailController.text
                  : null;
              final newPhone = userPhone != phoneController.text
                  ? phoneController.text
                  : null;
              final newAddress = userAddress != addressController.text
                  ? addressController.text
                  : null;
              bool changed = false;
              if (newName != null ||
                  newPhone != null ||
                  newPhone != null ||
                  newAddress != null) {
                changed = await UserServices.updateProfile(
                  context,
                  fullName: newName,
                  phoneNumber: newPhone,
                  userAddress: newAddress,
                );
              }
              bool emailChanged = false;
              if (context.mounted && newEmail != null) {
                emailChanged = await UserServices.changeUserEmail(
                  context,
                  newEmail,
                );
              }
              if (changed || emailChanged) {
                setState(() {
                  userName = nameController.text;
                  userEmail = emailController.text;
                  userPhone = phoneController.text;
                  userAddress = addressController.text;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show Booking History Dialog
  void _showBookingHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookingHistory.length,
                  itemBuilder: (context, index) {
                    final booking = bookingHistory[index];
                    return _buildBookingCard(booking);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Booking card widget
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final isCompleted = booking['status'] == 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking['chefName'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(booking['eventType'], style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(booking['date'], style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(booking['time'], style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking['amount'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8BC34A),
                ),
              ),
              if (booking['rating'] != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${booking['rating']}'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Payment Methods Dialog
  void _showPaymentMethodsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Methods'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPaymentMethodTile(
              'eSewa',
              Icons.account_balance_wallet,
              true,
            ),
            _buildPaymentMethodTile('Khalti', Icons.payment, false),
            _buildPaymentMethodTile('Fonepay', Icons.phone_android, false),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add new payment method'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Payment Method'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BC34A),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String name, IconData icon, bool isDefault) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8BC34A)),
      title: Text(name),
      trailing: isDefault
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Default',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      )
          : null,
    );
  }

  // Notifications Settings Dialog
  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Notification Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive all notifications'),
                value: notificationsEnabled,
                activeColor: const Color(0xFF8BC34A),
                onChanged: (value) {
                  setDialogState(() {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Email Notifications'),
                subtitle: const Text('Booking updates via email'),
                value: emailNotifications,
                activeColor: const Color(0xFF8BC34A),
                onChanged: notificationsEnabled
                    ? (value) {
                  setDialogState(() {
                    setState(() {
                      emailNotifications = value;
                    });
                  });
                }
                    : null,
              ),
              SwitchListTile(
                title: const Text('SMS Notifications'),
                subtitle: const Text('Booking updates via SMS'),
                value: smsNotifications,
                activeColor: const Color(0xFF8BC34A),
                onChanged: notificationsEnabled
                    ? (value) {
                  setDialogState(() {
                    setState(() {
                      smsNotifications = value;
                    });
                  });
                }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('In-app notifications'),
                value: pushNotifications,
                activeColor: const Color(0xFF8BC34A),
                onChanged: notificationsEnabled
                    ? (value) {
                  setDialogState(() {
                    setState(() {
                      pushNotifications = value;
                    });
                  });
                }
                    : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings updated!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BC34A),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // Help & Support Dialog
  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need assistance? We\'re here to help!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF8BC34A)),
                title: const Text('Email Support'),
                subtitle: const Text('support@cookmate.com'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email app...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF8BC34A)),
                title: const Text('Call Support'),
                subtitle: const Text('+977 9876543210'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening phone app...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Color(0xFF8BC34A)),
                title: const Text('Live Chat'),
                subtitle: const Text('Available 9 AM - 6 PM'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat feature coming soon!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
              const Divider(height: 30),
              const Text(
                'FAQs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ExpansionTile(
                title: const Text('How do I book a chef?'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Browse available chefs, select your preferred chef, choose a date and menu, then confirm your booking with payment.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Can I cancel my booking?'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Yes, you can cancel bookings up to 24 hours before the event. Full refund will be processed within 5-7 business days.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('What payment methods are accepted?'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'We accept eSewa, Khalti, Fonepay, and cash on service.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Privacy Policy Dialog
  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'CookMate Privacy Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Last updated: December 2025',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information We Collect',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We collect personal information such as your name, email, phone number, and address when you register for our service. We also collect booking history and payment information.',
              ),
              SizedBox(height: 16),
              Text(
                '2. How We Use Your Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your information is used to process bookings, facilitate communication between customers and chefs, and improve our services.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Data Security',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We implement industry-standard security measures to protect your personal information from unauthorized access, disclosure, or misuse.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Your Rights',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You have the right to access, update, or delete your personal information at any time through your profile settings.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Contact Us',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions about our privacy policy, please contact us at privacy@cookmate.com',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
            ),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

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
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Avatar with upload functionality
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(child: _profileImage),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8BC34A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    userPhone,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    userAddress,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Profile Options
              _buildProfileOption(
                context,
                Icons.edit,
                'Edit Profile',
                _showEditProfileDialog,
              ),
              _buildProfileOption(
                context,
                Icons.history,
                'Booking History',
                _showBookingHistoryDialog,
              ),
              _buildProfileOption(
                context,
                Icons.payment,
                'Payment Methods',
                _showPaymentMethodsDialog,
              ),
              _buildProfileOption(
                context,
                Icons.notifications,
                'Notifications',
                _showNotificationsDialog,
              ),
              _buildProfileOption(
                context,
                Icons.help,
                'Help & Support',
                _showHelpSupportDialog,
              ),
              _buildProfileOption(
                context,
                Icons.privacy_tip,
                'Privacy Policy',
                _showPrivacyPolicyDialog,
              ),
              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Helper.confirmLogOut(context),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
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

  Widget _buildProfileOption(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8BC34A)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}