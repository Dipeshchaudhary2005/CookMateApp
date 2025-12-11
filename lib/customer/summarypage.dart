import 'package:cookmate/backend/model/booking.dart';
import 'package:cookmate/backend/services/booking_services.dart';
import 'package:cookmate/customer/esewapaymentpage.dart';
import 'package:flutter/material.dart';
import 'ratingpage.dart';
import 'bookingpage.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late Booking currentBooking;
  late Future<Booking?> currentBookingFuture;
  String selectedEvent = 'Engagement Function';
  bool showAppetizers = false;
  bool showMainCourse = false;
  bool showSidesDesserts = false;
  bool showBeverages = false;

  @override
  void initState() {
    super.initState();
    currentBookingFuture = BookingServices.getCurrentBookings(context);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentBookingFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Color(0xFF8BC34A), // your app green
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white, // optional: makes it visible on green
                ),
              ),
            );
          }
          if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
            return const Center(child: Text("No ongoing booking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),);
          }
          currentBooking = asyncSnapshot.data!;
          selectedEvent = currentBooking.eventType ?? BookingPage.eventList[0];
          return Scaffold(
              backgroundColor: const Color(0xFFB8E6B8),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentBooking.status ?? "Unknown",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  GestureDetector(
                    onTap: (currentBooking.paymentStatus != null && currentBooking.paymentStatus!) ? null : () {
                      showDialog(
                          context: context,
                          builder: (dialogContext) =>
                              AlertDialog(
                                title: const Text('Complete Payment'),
                                content: const Text('Are you sure you want to complete the payment'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel')
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EsewaPaymentPage(bookingId: currentBooking.id!,
                                                    productName: currentBooking.chefName!,
                                                    customerName: currentBooking.customerName!,
                                                    customerPhone: currentBooking.customerPhone!)
                                        )
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8BC34A),
                                    ),
                                    child: const Text('Confirm'),
                                  )
                                ],
                              )
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: (currentBooking.paymentStatus != null && currentBooking.paymentStatus!) ? Colors.blue : const Color(0xFF8BC34A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (currentBooking.paymentStatus != null && currentBooking.paymentStatus!) ? 'Paid' : 'Pay',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (dialogContext) =>
                            AlertDialog(
                              title: const Text('Confirm Booking'),
                              content: const Text(
                                'Are you sure you want to confirm this booking?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Booking confirmed successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    // Navigate to rating page after 1 second
                                    Future.delayed(const Duration(seconds: 1), () {
                                      if (!context.mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RatingPage(currentBooking: currentBooking,),
                                        ),
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8BC34A),
                                  ),
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8BC34A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Price: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'NPR ${currentBooking.cost}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Date of Event Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB3D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.purple),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentBooking.date.toString().split(' ')[0],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currentBooking.timeInterval ?? 'null',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Type of Event
                    const Text(
                      'Type of Event',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB3D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.celebration, size: 30),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedEvent,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items:
                              BookingPage.eventList
                                  .map(
                                    (e) =>
                                    DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                              )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => selectedEvent = val!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Menu Section
                    const Text(
                      'Menu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: currentBooking.packages?.length ?? 0,
                      itemBuilder: (context, index) {
                        final package = currentBooking.packages![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  package['name'] ?? 'No name',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Dishes:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ...package['dishes'].map((dish) => Text("• $dish")).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Chef Details
                    const Text(
                      'Chef Details',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB3D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                currentBooking.chefUrlToImage ?? 'null',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person, size: 30);
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
                                  currentBooking.chefName ?? 'No name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currentBooking.chefSpeciality ?? 'null',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  '${currentBooking.chefExperience} of Experience',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          );
        });

  }

}
