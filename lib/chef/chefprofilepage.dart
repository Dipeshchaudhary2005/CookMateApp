import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/backend/services/fetch_services.dart';
import 'package:cookmate/backend/services/user_services.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChefProfilePage extends StatefulWidget {
  const ChefProfilePage({super.key});

  @override
  State<ChefProfilePage> createState() => _ChefProfilePageState();
}

class _ChefProfilePageState extends State<ChefProfilePage> {
  UserModel chef = StaticClass.currentUser!;
  Image? _profileImage = StaticClass.currentUser!.urlToImage != null
      ? Image.network(StaticClass.currentUser!.urlToImage!, fit: BoxFit.cover)
      : null;
  final ImagePicker _picker = ImagePicker();

  // Chef data
  int totalBookings = 127;
  int completedBookings = 115;
  String? selectedCuisine;
  String? selectedSpeciality = StaticClass.currentUser!.speciality;

  // Monthly income data (example)
  final List<double> monthlyIncome = [
    4500, 5200, 4800, 6100, 5800, 6500, 7200, 6800, 7500, 8100, 7800, 8500
  ];

  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        if (!mounted) return;
        bool changed = await UserServices.updateProfilePic(
          context,
          File(pickedFile.path),
        );
        if (!changed) return;
        setState(() {
          _profileImage = StaticClass.currentUser!.urlToImage != null
              ? Image.network(
            StaticClass.currentUser!.urlToImage!,
            fit: BoxFit.cover,
          )
              : null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

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

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _showPaymentAnalysis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentAnalysisSheet(
        monthlyIncome: monthlyIncome,
        months: months,
        chefName: chef.fullName ?? "Chef",
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: chef.fullName);
    final experienceController = TextEditingController(text: chef.experience);
    final emailController = TextEditingController(text: chef.email);
    final phoneController = TextEditingController(text: chef.phoneNumber);
    final addressController = TextEditingController(text: chef.userAddress);
    final bioController = TextEditingController(text: chef.bio);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      hint: Text("Select speciality"),
                      icon: Icon(Icons.work),
                      borderRadius: BorderRadius.circular(8.0),
                      isExpanded: true,
                      value: selectedSpeciality,
                      items: chef.cuisines!
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                      )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedSpeciality = val;
                        });
                        setDialogState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Experience',
                      prefixIcon: Icon(Icons.work),
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
                      labelText: 'Phone',
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: Icon(Icons.notes),
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
                          final newName = nameController.text != chef.fullName
                              ? nameController.text
                              : null;
                          final speciality =
                          selectedSpeciality != chef.speciality
                              ? selectedSpeciality
                              : null;
                          final experience =
                          experienceController.text != chef.experience
                              ? experienceController.text
                              : null;
                          final email = emailController.text != chef.email
                              ? emailController.text
                              : null;
                          final phone = phoneController.text != chef.phoneNumber
                              ? phoneController.text
                              : null;
                          final address =
                          addressController.text != chef.userAddress
                              ? addressController.text
                              : null;
                          final bioField = bioController.text != chef.bio
                              ? bioController.text
                              : null;
                          bool changedProfile = false;
                          bool changedChefFields = false;
                          bool changedEmail = false;
                          if (newName != null ||
                              phone != null ||
                              address != null ||
                              bioField != null) {
                            changedProfile = await UserServices.updateProfile(
                              context,
                              fullName: newName,
                              phoneNumber: phone,
                              userAddress: address,
                              bio: bioField,
                            );
                          }
                          if (speciality != null || experience != null) {
                            if (!context.mounted) return;
                            changedChefFields =
                            await UserServices.updateChefFields(
                              context,
                              speciality: speciality,
                              experience: experience,
                            );
                          }
                          if (email != null) {
                            if (!context.mounted) return;
                            changedEmail = await UserServices.changeUserEmail(
                              context,
                              email,
                            );
                          }
                          if (changedEmail ||
                              changedChefFields ||
                              changedProfile) {
                            setState(() {
                              chef = StaticClass.currentUser!;
                            });
                          }
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated!'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSpecializationsDialog() {
    List<String> tempSpecializations = List.from(chef.cuisines ?? List.empty());
    late Future<List<String>?> cuisinesList = FetchServices.getCuisines(context);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Manage Specializations'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<String>?>(
                        future: cuisinesList,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
                                value: selectedCuisine,
                                underline: const SizedBox(),
                                items: snapshot.data!
                                    .map(
                                      (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() => selectedCuisine = val!);
                                  setDialogState(() {});
                                },
                              );
                            } else {
                              return Text("No data found");
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedCuisine != null) {
                          setDialogState(() {
                            tempSpecializations.add(selectedCuisine!);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tempSpecializations.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(tempSpecializations[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setDialogState(() {
                                tempSpecializations.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
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
                bool changed = await UserServices.updateChefFields(
                  context,
                  cuisines: tempSpecializations,
                );
                if (!changed) return;
                setState(() {
                  chef = StaticClass.currentUser!;
                  if (!chef.cuisines!.contains(selectedSpeciality)) {
                    selectedSpeciality = chef.cuisines!.first;
                  }
                });
                if (!context.mounted) return;
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8E6B8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.payment, color: Colors.black),
            onPressed: _showPaymentAnalysis,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: _navigateToSettings,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: const Color(0xFFB8E6B8),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: _profileImage != null
                            ? ClipOval(child: _profileImage)
                            : const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
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
                  const SizedBox(height: 16),
                  Text(
                    chef.fullName ?? "No name",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chef.speciality ?? "No speciality",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${chef.rating ?? 0.0}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.work, size: 20, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        chef.experience ?? "No experience",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Statistics Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total\nBookings',
                      '$totalBookings',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      '$completedBookings',
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Rating',
                      '${chef.rating ?? 0.0}',
                      Colors.amber,
                    ),
                  ),
                ],
              ),
            ),

            // About Section
            _buildSection(
              'About',
              chef.bio ?? "No bio",
              Icons.info_outline,
              onTap: _showEditProfileDialog,
            ),

            // Contact Information
            _buildInfoCard('Contact Information', [
              {
                'icon': Icons.email,
                'label': 'Email',
                'value': chef.email ?? "No email",
              },
              {
                'icon': Icons.phone,
                'label': 'Phone',
                'value': chef.phoneNumber ?? "No phone",
              },
              {
                'icon': Icons.location_on,
                'label': 'Address',
                'value': chef.userAddress ?? "No address",
              },
            ]),

            // Specializations
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Specializations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: _showSpecializationsDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: chef.cuisines!.map((spec) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8E6B8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(spec),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title,
      String content,
      IconData icon, {
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF8BC34A)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (onTap != null)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onTap,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Map<String, dynamic>> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 20,
                    color: const Color(0xFF8BC34A),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          item['value'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool bookingAlerts = true;
  bool messageAlerts = true;
  bool promotionalEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8E6B8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification Settings
          _buildSectionHeader('Notification Settings'),
          _buildSettingsCard([
            _buildSwitchTile(
              'Push Notifications',
              'Receive notifications on your device',
              Icons.notifications_active,
              pushNotifications,
                  (value) => setState(() => pushNotifications = value),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              'Email Notifications',
              'Get updates via email',
              Icons.email,
              emailNotifications,
                  (value) => setState(() => emailNotifications = value),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              'SMS Notifications',
              'Receive SMS for important updates',
              Icons.message,
              smsNotifications,
                  (value) => setState(() => smsNotifications = value),
            ),
          ]),

          const SizedBox(height: 20),

          // Alert Preferences
          _buildSectionHeader('Alert Preferences'),
          _buildSettingsCard([
            _buildSwitchTile(
              'Booking Alerts',
              'New booking requests and updates',
              Icons.calendar_today,
              bookingAlerts,
                  (value) => setState(() => bookingAlerts = value),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              'Message Alerts',
              'New messages from customers',
              Icons.chat,
              messageAlerts,
                  (value) => setState(() => messageAlerts = value),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              'Promotional Emails',
              'Special offers and tips',
              Icons.local_offer,
              promotionalEmails,
                  (value) => setState(() => promotionalEmails = value),
            ),
          ]),

          const SizedBox(height: 20),

          // Other Settings
          _buildSectionHeader('Other Settings'),
          _buildSettingsCard([
            _buildNavigationTile(
              'Privacy Policy',
              Icons.privacy_tip,
                  () {},
            ),
            const Divider(height: 1),
            _buildNavigationTile(
              'Terms of Service',
              Icons.description,
                  () {},
            ),
            const Divider(height: 1),
            _buildNavigationTile(
              'Help & Support',
              Icons.help,
                  () {},
            ),
          ]),

          const SizedBox(height: 30),

          // Save Button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
      String title,
      String subtitle,
      IconData icon,
      bool value,
      Function(bool) onChanged,
      ) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      secondary: Icon(icon, color: const Color(0xFF8BC34A)),
      value: value,
      activeThumbColor: const Color(0xFF8BC34A),
      onChanged: onChanged,
    );
  }

  Widget _buildNavigationTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8BC34A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// Payment Analysis Bottom Sheet
class PaymentAnalysisSheet extends StatelessWidget {
  final List<double> monthlyIncome;
  final List<String> months;
  final String chefName;

  const PaymentAnalysisSheet({
    super.key,
    required this.monthlyIncome,
    required this.months,
    required this.chefName,
  });

  @override
  Widget build(BuildContext context) {
    // final totalIncome = monthlyIncome.reduce((a, b) => a + b);
    // final avgIncome = totalIncome / monthlyIncome.length;
    // final currentMonth = DateTime
    //     .now()
    //     .month - 1;
    // final currentIncome = monthlyIncome[currentMonth];

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Income Analysis',
                  style: TextStyle(
                    fontSize: 24,
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildIncomeCard(
                          'This Month',
                          '\${currentIncome.toStringAsFixed(0)}',
                          Icons.calendar_month,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildIncomeCard(
                          'Average',
                          '\${avgIncome.toStringAsFixed(0)}',
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Chart
                  const Text(
                    'Monthly Income Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\${(value / 1000).toStringAsFixed(0)}k',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < months.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      months[value.toInt()],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              monthlyIncome.length,
                                  (i) => FlSpot(i.toDouble(), monthlyIncome[i]),
                            ),
                            isCurved: true,
                            color: const Color(0xFF8BC34A),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF8BC34A).withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QR Code Section
                  const Text(
                    'Payment QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: 'upi://pay?pa=chef@bank&pn=$chefName&cu=USD',
                          version: QrVersions.auto,
                          size: 200,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Scan to Pay $chefName',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8E6B8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'UPI Payment Enabled',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Share this QR code with customers for quick payments',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeCard(String label,
      String value,
      IconData icon,
      Color color,) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:  0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}