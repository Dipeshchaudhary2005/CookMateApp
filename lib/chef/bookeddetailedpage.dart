import 'package:cookmate/backend/model/booking.dart';
import 'package:cookmate/backend/services/booking_services.dart';
import 'package:flutter/material.dart';

class BookedDetailsPage extends StatefulWidget {
  const BookedDetailsPage({super.key});

  @override
  State<BookedDetailsPage> createState() => _BookedDetailsPageState();
}

class _BookedDetailsPageState extends State<BookedDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Booking> bookings;
  late Future<List<Booking>?> bookingsFuture;
  late List<Booking> pendingBookings;
  late List<Booking> cancelledBookings;
  late List<Booking> confirmedBookings;
  late List<Booking> completedBookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    bookingsFuture = BookingServices.getBookings(context, 'chef');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _acceptBooking(Booking booking) async {
    final success = await BookingServices.updateStatus(context, booking.id!, BookingStatus.upcoming.name);
    if (success == null || !success){
      return;
    }
    setState(() {
      booking.status = BookingStatus.upcoming.name;
      _tabController.animateTo(1);
    });
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelBooking(Booking booking) async {
    final success = await BookingServices.updateStatus(context, booking.id!, BookingStatus.cancelled.name);
    if (success == null || !success) return;
    setState(() {
      booking.status = BookingStatus.cancelled.name;
      _tabController.animateTo(3);
    });
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Cancelled'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _completeBooking(Booking booking) async {
    final success = await BookingServices.updateStatus(context, booking.id!, BookingStatus.completed.name);
    if (success == null || !success) return;
    setState(() {
      booking.status = BookingStatus.completed.name;
      _tabController.animateTo(2);
    });
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking marked as completed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.person, 'Customer', booking.customerName ?? "null"),
                _buildDetailRow(Icons.event, 'Event Type', booking.eventType ?? "null"),
                _buildDetailRow(Icons.calendar_today, 'Date', booking.date?.toString() ?? 'null'),
                _buildDetailRow(Icons.access_time, 'Time', booking.timeInterval ?? 'null'),
                _buildDetailRow(
                  Icons.people,
                  'Guests',
                  '${booking.noOfPeople} People',
                ),
                _buildDetailRow(
                  Icons.restaurant_menu,
                  'Package',
                  booking.packages.toString(),
                ),
                _buildDetailRow(Icons.phone, 'Phone', booking.customerPhone ?? 'null'),
                _buildDetailRow(
                  Icons.location_on,
                  'Address',
                  booking.customerAddress ?? 'null',
                ),
                const Divider(),
                _buildDetailRow(Icons.money, 'Total Amount', booking.cost.toString()),
                if (booking.rating != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Rating: ${booking.rating}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                if (booking.status == BookingStatus.pending.name)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _acceptBooking(booking),
                          icon: const Icon(Icons.check),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _cancelBooking(booking),
                          icon: const Icon(Icons.close),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (booking.status == BookingStatus.upcoming.name) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _completeBooking(booking),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Customer contacted'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Contact Customer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8BC34A),
                        side: const BorderSide(color: Color(0xFF8BC34A)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF8BC34A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String pendingCount = '0';
    String upcomingCount = '0';
    String completedCount = '0';
    String cancelledCount = '0';
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
          'All Bookings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          isScrollable: false,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text('Pending', overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pendingCount,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text('Confirmed', overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      upcomingCount,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text('Completed', overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      completedCount,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text('Cancelled', overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cancelledCount,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Booking>?>(
        future: bookingsFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done){
            return const Center(child: CircularProgressIndicator(),);
          }
          if (!asyncSnapshot.hasData || asyncSnapshot.data == null){
            return const Center(child: Text("No bookings"),);
          }
          bookings = asyncSnapshot.data!;
          pendingBookings = bookings.where((e) => e.status == BookingStatus.pending.name).toList();
          confirmedBookings = bookings.where((e) => e.status == BookingStatus.upcoming.name).toList();
          cancelledBookings = bookings.where((e) => e.status == BookingStatus.cancelled.name).toList();
          completedBookings = bookings.where((e) => e.status == BookingStatus.completed.name).toList();
            pendingCount = '${pendingBookings.length}';
            upcomingCount = '${confirmedBookings.length}';
            completedCount = '${completedBookings.length}';
            cancelledCount = '${cancelledBookings.length}';
          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(pendingBookings, 'pending'),
              _buildBookingList(confirmedBookings, 'confirmed'),
              _buildBookingList(completedBookings, 'completed'),
              _buildBookingList(cancelledBookings, 'cancelled')
            ],
          );
        }
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, String status) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No $status bookings',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor = booking.status! == BookingStatus.pending.name
        ? Colors.orange
        : booking.status! == BookingStatus.completed.name
        ? Colors.green
        : booking.status! == BookingStatus.cancelled.name
        ? Colors.red
        : Colors.blue;

    return GestureDetector(
      onTap: () => _showBookingDetails(booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFB8E6B8),
                  child: Text(
                    booking.customerName?[0] ?? 'N',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName ?? "No name",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking.eventType ?? "No event type",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status?.toUpperCase() ?? "No status",
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(booking.date.toString(), style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking.timeInterval ?? "No interval",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${booking.noOfPeople ?? 'Null'} Guests',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    booking.cost?.toString() ?? "No cost",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8BC34A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (booking.rating != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('Rating: ${booking.rating}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
