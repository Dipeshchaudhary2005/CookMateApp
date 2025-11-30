import 'package:cookmate/backend/services/fetch_services.dart';
import 'package:flutter/material.dart';
import 'summarypage.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedEvent;
  DateTime selectedDate = DateTime.now();
  String selectedTime = '8:00 AM - 12:00 PM';
  String? selectedPackage;
  List<String> selectedFoodItems = [];
  List<String> customMenuItems = [];
  late Future<List<String>?> cuisinesList;
  late Future<List<String>> eventList;
  // Food items for different packages
  final Map<String, List<String>> packageFoodItems = {
    '2-Course Dinner': [
      'Chicken Tikka',
      'Paneer Curry',
      'Dal Makhani',
      'Naan Bread',
      'Rice',
      'Gulab Jamun',
    ],
    'Private Cooking': [
      'Appetizer Platter',
      'Caesar Salad',
      'Grilled Salmon',
      'Pasta Alfredo',
      'Garlic Bread',
      'Chocolate Mousse',
      'Fresh Fruits',
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadData(context);
  }

  void _loadData(BuildContext context) {
    cuisinesList = FetchServices.getCuisines(context);
    eventList = emptyList();
  }

  Future<List<String>> emptyList() async {
    return List<String>.empty();
  }

  // Method to show calendar
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8BC34A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Method to show food selection dialog
  void _showFoodSelectionDialog(String packageName) {
    List<String> tempSelected = List.from(selectedFoodItems);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Select Food Items - $packageName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: packageFoodItems[packageName]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = packageFoodItems[packageName]![index];
                    final isSelected = tempSelected.contains(item);

                    return CheckboxListTile(
                      title: Text(item),
                      value: isSelected,
                      activeColor: const Color(0xFF8BC34A),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFoodItems = tempSelected;
                      selectedPackage = packageName;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${tempSelected.length} items selected'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                  ),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to show custom menu dialog
  void _showCustomMenuDialog() {
    final TextEditingController customItemController = TextEditingController();
    List<String> tempCustomItems = List.from(customMenuItems);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Add Custom Menu Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Input field for new item
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: customItemController,
                            decoration: InputDecoration(
                              hintText: 'Enter dish name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (customItemController.text.isNotEmpty) {
                              setDialogState(() {
                                tempCustomItems.add(customItemController.text);
                                customItemController.clear();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // List of added items
                    if (tempCustomItems.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: tempCustomItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                dense: true,
                                title: Text(tempCustomItems[index]),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setDialogState(() {
                                      tempCustomItems.removeAt(index);
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
                  onPressed: () {
                    setState(() {
                      customMenuItems = tempCustomItems;
                      selectedPackage = 'Custom Menu';
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${tempCustomItems.length} custom items added',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                  ),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to show payment dialog
  void _showPaymentDialog() {
    if (selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Payment Method',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentOption(
                'eSewa',
                'assets/esewa_logo.png',
                Colors.green[700]!,
                () {
                  Navigator.pop(context);
                  _processPayment('eSewa');
                },
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'Fonepay',
                'assets/fonepay_logo.png',
                Colors.blue[700]!,
                () {
                  Navigator.pop(context);
                  _processPayment('Fonepay');
                },
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'Khalti',
                'assets/khalti_logo.png',
                Colors.purple[700]!,
                () {
                  Navigator.pop(context);
                  _processPayment('Khalti');
                },
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'Cash on Service',
                null,
                Colors.orange[700]!,
                () {
                  Navigator.pop(context);
                  _processPayment('Cash on Service');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to process payment and navigate
  void _processPayment(String paymentMethod) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF8BC34A)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment via $paymentMethod successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SummaryPage()),
        );
      }
    });
  }

  Widget _buildPaymentOption(
    String title,
    String? logoPath,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: logoPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        logoPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.payment, color: color, size: 30);
                        },
                      ),
                    )
                  : Icon(Icons.money, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book a Chef',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type of Event
              const Text(
                'Type of Event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FutureBuilder<List<String>>(
                  future: eventList,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      return DropdownButton<String>(
                        value: selectedEvent,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: asyncSnapshot.data!
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        // items: ['Engagement Function', 'Birthday Party', 'Wedding']
                        //     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        //     .toList(),
                        onChanged: (val) =>
                            setState(() => selectedEvent = val!),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Select Date - WITH CALENDAR
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF8BC34A),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Select Hours
              const Text(
                'Select Hours',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedTime,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items:
                      [
                            '8:00 AM - 12:00 PM',
                            '12:00 PM - 4:00 PM',
                            '4:00 PM - 8:00 PM',
                            '8:00 PM - 12:00 AM',
                          ]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => selectedTime = val!),
                ),
              ),
              const SizedBox(height: 20),

              // Select Package
              const Text(
                'Select Package',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 2-Course Dinner - WITH FOOD SELECTION
              _buildPackageCard(
                '2-Course Dinner',
                'Good - NPR 650 Combo',
                'Dine in 2-course/guest',
                Colors.white,
                onTap: () => _showFoodSelectionDialog('2-Course Dinner'),
                isSelected: selectedPackage == '2-Course Dinner',
                selectedCount: selectedPackage == '2-Course Dinner'
                    ? selectedFoodItems.length
                    : 0,
                showAddButton: true,
              ),
              const SizedBox(height: 12),

              // Private Cooking - WITH FOOD SELECTION
              _buildPackageCard(
                'Private Cooking',
                'Opens Morning',
                'Very Good 4-course/guest',
                Colors.white,
                onTap: () => _showFoodSelectionDialog('Private Cooking'),
                isSelected: selectedPackage == 'Private Cooking',
                selectedCount: selectedPackage == 'Private Cooking'
                    ? selectedFoodItems.length
                    : 0,
                showAddButton: true,
              ),
              const SizedBox(height: 12),

              // Custom Menu - WITH ADD BUTTON
              _buildPackageCard(
                'Custom Menu',
                'Unspecified contact',
                'Dine out booking/guest',
                Colors.white,
                onTap: _showCustomMenuDialog,
                isSelected: selectedPackage == 'Custom Menu',
                selectedCount: selectedPackage == 'Custom Menu'
                    ? customMenuItems.length
                    : 0,
                showAddButton: true,
              ),
              const SizedBox(height: 30),

              // Book Now Button - Show Payment Dialog
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showPaymentDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(
    String title,
    String price,
    String description,
    Color color, {
    VoidCallback? onTap,
    bool isSelected = false,
    int selectedCount = 0,
    bool showAddButton = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF8BC34A), width: 3)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isSelected && selectedCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8BC34A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$selectedCount items',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(fontSize: 14)),
                  Text(description, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            if (showAddButton)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              )
            else
              Icon(
                isSelected ? Icons.check_circle : Icons.help_outline,
                color: isSelected ? const Color(0xFF8BC34A) : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
