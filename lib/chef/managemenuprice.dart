import 'package:flutter/material.dart';

class ManageMenuPricePage extends StatefulWidget {
  const ManageMenuPricePage({super.key});

  @override
  State<ManageMenuPricePage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPricePage> {
  String selectedCategory = 'All';

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
          'Manage Menu & Pricing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Appetizers'),
                _buildCategoryChip('Main Course'),
                _buildCategoryChip('Desserts'),
                _buildCategoryChip('Beverages'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Menu Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMenuItem(
                  'Grilled Salmon',
                  'Main Course',
                  '\$45.00',
                  'assets/salmon.png',
                  'Italian',
                ),
                _buildMenuItem(
                  'Caesar Salad',
                  'Appetizers',
                  '\$15.00',
                  'assets/salad.png',
                  'Italian',
                ),
                _buildMenuItem(
                  'Tiramisu',
                  'Desserts',
                  '\$12.00',
                  'assets/tiramisu.png',
                  'Italian',
                ),
                _buildMenuItem(
                  'Beef Wellington',
                  'Main Course',
                  '\$65.00',
                  'assets/beef.png',
                  'British',
                ),
                _buildMenuItem(
                  'Bruschetta',
                  'Appetizers',
                  '\$18.00',
                  'assets/bruschetta.png',
                  'Italian',
                ),
                _buildMenuItem(
                  'Chocolate Mousse',
                  'Desserts',
                  '\$14.00',
                  'assets/mousse.png',
                  'French',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMenuDialog(context);
        },
        backgroundColor: const Color(0xFF8BC34A),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = category;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFFFB3D9),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String name,
      String category,
      String price,
      String imagePath,
      String cuisine,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8E6B8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cuisine,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8BC34A),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  _showEditMenuDialog(context, name, category, price);
                },
                color: Colors.blue,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () {
                  _showDeleteDialog(context, name);
                },
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMenuDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Main Course';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Appetizers', 'Main Course', 'Desserts', 'Beverages']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => selectedCategory = val!,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu item added successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditMenuDialog(
      BuildContext context, String name, String category, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Menu Item'),
        content: Text('Edit details for: $name'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu item updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu item deleted!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}