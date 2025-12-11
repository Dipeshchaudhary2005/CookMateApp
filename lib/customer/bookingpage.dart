import 'package:cookmate/backend/model/chef_package.dart';
import 'package:cookmate/backend/services/booking_services.dart';
import 'package:cookmate/backend/services/chef_packages_services.dart';
import 'package:cookmate/core/helper.dart';
import 'package:flutter/material.dart';
class BookingPage extends StatefulWidget {
  final String? chefId;
  const BookingPage({super.key, this.chefId});
  static const List<String> eventList = [
    "Wedding", "Birthday", "Home Cooking", "Private"
  ];

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isLoading = false;
  num cost = 0;
  String? selectedEvent;
  DateTime selectedDate = DateTime.now();
  String selectedTime = '8:00 AM - 12:00 PM';
  int? selectedNoOfPeople = 1;
  List<String> selectedFoodItems = [];
  List<String> customMenuItems = [];
  late Future<List<ChefPackage>?> packagesFuture;
  late List<ChefPackage>? packages;
  List<ChefPackage> selectedPackages = [];
  TextEditingController? noOfPeopleController;


  @override
  void initState() {
    super.initState();
    packagesFuture = ChefPackagesServices.getChefsPackages(context, widget.chefId ?? "6927ca2145f9994a3fbe538e");
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
    // Deep copy of selectedPackages
    List<ChefPackage> tempSelected = List.from(selectedPackages);

    // The package the user selected
    final ChefPackage selectedPackageModel =
    packages!.firstWhere((p) => p.name == packageName);

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
                  itemCount: selectedPackageModel.dishes!.length,
                  itemBuilder: (context, index) {
                    final item = selectedPackageModel.dishes![index];

                    // Get the temp copy of this package
                    final tempPkg = tempSelected.firstWhere(
                          (p) => p.name == packageName,
                      orElse: ()  {
                            final pkg = ChefPackage(id: selectedPackageModel.id!, name: packageName, dishes: [], price: selectedPackageModel.price);
                            tempSelected.add(pkg);
                            return pkg;
                            },
                    );

                    final isSelected = tempPkg.dishes!.contains(item);

                    return CheckboxListTile(
                      title: Text(item),
                      value: isSelected,
                      activeColor: const Color(0xFF8BC34A),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempPkg.dishes!.add(item);
                          } else {
                            tempPkg.dishes!.remove(item);
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
                    tempSelected.removeWhere((e) => e.dishes?.isEmpty ?? true);
                    num sum = 0;
                    for(var e in tempSelected){
                      sum += e.price ?? 0;
                    }
                    setState(() {
                      selectedPackages = tempSelected;
                      cost = sum * (int.tryParse(noOfPeopleController?.text ?? '1') ?? 1);
                    });
                    Navigator.pop(context);

                    final selectedCount = tempSelected
                        .firstWhere((p) => p.name == packageName, orElse: () => ChefPackage(dishes: []))
                        .dishes!
                        .length;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$selectedCount items selected'),
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

  @override
  Widget build(BuildContext context) {
    noOfPeopleController = TextEditingController(text: selectedNoOfPeople.toString());
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
      body: Padding(
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
              child: DropdownButton<String>(
                      value: selectedEvent,
                      isExpanded: true,
                      items: BookingPage.eventList
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedEvent = val!),
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
            const SizedBox(height: 8,),
            const Text(
              'Select No of People',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: noOfPeopleController,

              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                if (value.isNotEmpty){
                  selectedNoOfPeople = int.tryParse(value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Select Package
            const Text(
              'Select Package',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<ChefPackage>?>
                (future: packagesFuture,
                  builder: (context, snapshot) {
                   if (snapshot.connectionState != ConnectionState.done){
                     return Center(child: const CircularProgressIndicator());
                   }else {
                     if (!snapshot.hasData){
                       return Text("No packages");
                     } else {
                       packages = snapshot.data;
                       return ListView.builder(

                         padding: const EdgeInsets.symmetric(vertical: 10),
                         itemCount: packages!.length,
                         itemBuilder: (context, index) {
                           final package = packages![index];

                           final isSelected = selectedPackages.any((e) => e.name == package.name);

                           final selectedPkg = selectedPackages.firstWhere(
                                 (p) => p.name == package.name,
                             orElse: () => ChefPackage(name: package.name, dishes: []),
                           );

                           final selectedCount = selectedPkg.dishes?.length ?? 0;

                           return _buildPackageCard(
                             package.name ?? "No name",
                             "NPR ${package.price} per person",
                             package.description!,
                             Colors.white,
                             onTap: () => _showFoodSelectionDialog(package.name!),
                             isSelected: isSelected,
                             selectedCount: selectedCount,
                             showAddButton: true,
                           );
                         },
                       );
                     }
                   }
                  }),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Text("Total Cost: NPR $cost", style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              )
            ),
            SizedBox(height: 20,),
            // Book Now Button - Show Payment Dialog
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // onPressed: _showPaymentDialog,
                onPressed: _isLoading ? null : () async{
                  if (noOfPeopleController!.text.isEmpty){
                    Helper.showError(context, "Enter number of people");
                    return;
                  }
                  selectedNoOfPeople = int.tryParse(noOfPeopleController!.text);
                  if (selectedNoOfPeople == null){
                    Helper.showError(context, "The number of people must be a integer");
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  final booking = await BookingServices.createBooking(context, widget.chefId!, selectedEvent!, selectedDate.toString(),
                      selectedTime, selectedNoOfPeople!, selectedPackages
                    );
                  setState(() {
                    _isLoading = false;
                  });
                  if (booking == null) return;
                  if (context.mounted){
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Booking made successfully"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading ? const CircularProgressIndicator() : const Text(
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
