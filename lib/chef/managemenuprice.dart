import 'package:cookmate/backend/model/chef_package.dart';
import 'package:cookmate/backend/services/chef_packages_services.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/material.dart';

class ManageMenuPricePage extends StatefulWidget {
  const ManageMenuPricePage({super.key});

  @override
  State<ManageMenuPricePage> createState() => _ManageMenuPricePageState();
}

class _ManageMenuPricePageState extends State<ManageMenuPricePage> {
  // Package data
  late List<ChefPackage> packages;
  late Future<List<ChefPackage>?> packagesFuture;

  void _addPackage() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Package'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Package Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (NPR)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
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
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  descController.text.isNotEmpty) {
                final newPackage = await ChefPackagesServices.createPackage(
                  context,
                  nameController.text,
                  descController.text,
                  num.parse(priceController.text),
                );
                if (newPackage == null) return;
                setState(() {
                  packages.add(newPackage);
                });
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Package added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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

  void _editPackage(int index) {
    final package = packages[index];
    final nameController = TextEditingController(text: package.name);
    final priceController = TextEditingController(
      text: package.price.toString(),
    );
    final descController = TextEditingController(text: package.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Package'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Package Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (NPR)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
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
              bool changed = await ChefPackagesServices.updatePackage(
                context,
                package.id!,
                name: nameController.text,
                price: num.parse(priceController.text),
                description: descController.text,
              );
              if (!changed) return;
              setState(() {
                packages[index].name = nameController.text;
                packages[index].price = num.parse(priceController.text);
                packages[index].description = descController.text;
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Package updated!'),
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
    );
  }

  void _manageMenuItems(int packageIndex) {
    final package = packages[packageIndex];
    List<String> tempItems = List.from(package.dishes ?? List.empty());
    final controller = TextEditingController();

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Menu Items - ${package.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Add menu item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          setDialogState(() {
                            tempItems.add(controller.text);
                            controller.clear();
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
                Expanded(
                  child: tempItems.isEmpty
                      ? const Center(child: Text('No menu items added yet'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: tempItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.restaurant_menu,
                                  color: Color(0xFF8BC34A),
                                ),
                                title: Text(tempItems[index]),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setDialogState(() {
                                      tempItems.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
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
                        bool updated = await ChefPackagesServices.updatePackage(
                          context,
                          package.id!,
                          dishes: tempItems,
                        );
                        if (!updated) return;
                        setState(() {
                          packages[packageIndex].dishes = tempItems;
                        });
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menu items updated!'),
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
    );
  }

  void _deletePackage(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Package'),
        content: Text(
          'Are you sure you want to delete "${packages[index].name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool deleted = await ChefPackagesServices.deletePackage(
                context,
                packages[index].id!,
              );
              if (!deleted) return;
              setState(() {
                packages.removeAt(index);
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Package deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    packagesFuture = ChefPackagesServices.getChefsPackages(context, StaticClass.currentUser!.uid!);
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
          'Manage Menu & Pricing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<ChefPackage>?>(
        future: packagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            packages = snapshot.data ?? List<ChefPackage>.empty();
            return Column(
              children: [
                // Stats Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB3D9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        '${packages.length}',
                        'Total Packages',
                        Icons.restaurant_menu,
                      ),
                      Container(width: 1, height: 40, color: Colors.black26),
                      _buildStatItem(
                        '${packages.where((p) => p.isActive ?? false).length}',
                        'Active',
                        Icons.check_circle,
                      ),
                      Container(width: 1, height: 40, color: Colors.black26),
                      _buildStatItem(
                        'NPR ${_calculateAvgPrice()}',
                        'Avg Price',
                        Icons.money,
                      ),
                    ],
                  ),
                ),

                // Package List Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Packages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addPackage,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Package'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BC34A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Package List
                Expanded(
                  child: packages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No packages yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _addPackage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8BC34A),
                                ),
                                child: const Text('Add Your First Package'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: packages.length,
                          itemBuilder: (context, index) {
                            return _buildPackageCard(index);
                          },
                        ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.black87, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  String _calculateAvgPrice() {
    if (packages.isEmpty) return '0';
    final activePackages = packages.where((p) => p.price! > 0);
    if (activePackages.isEmpty) return '0';
    final sum = activePackages.fold(0.0, (sum, p) => sum + (p.price!));
    return (sum / activePackages.length).toStringAsFixed(0);
  }

  Widget _buildPackageCard(int index) {
    final package = packages[index];
    final isActive = package.isActive ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xFF8BC34A) : Colors.grey[300]!,
          width: 2,
        ),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  package.name ?? "No name",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Switch(
                                value: isActive,
                                activeThumbColor: const Color(0xFF8BC34A),
                                onChanged: (value) {
                                  setState(() {
                                    packages[index].isActive = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            package.description ?? "No description",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            package.price == 0
                                ? 'Custom Pricing'
                                : 'NPR ${package.price}/guest',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8BC34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${package.dishes?.length ?? 0} menu items',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => _editPackage(index),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8BC34A),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _manageMenuItems(index),
                  icon: const Icon(Icons.restaurant_menu, size: 18),
                  label: const Text('Menu'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8BC34A),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _deletePackage(index),
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
