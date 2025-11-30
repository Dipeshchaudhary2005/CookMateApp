import 'package:flutter/material.dart';

class BookedDetailsPage extends StatefulWidget {
  const BookedDetailsPage({super.key});

  @override
  State<BookedDetailsPage> createState() => _BookedDetailsPageState();
}

class _BookedDetailsPageState extends State<BookedDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample booking data
  List<Map<String, dynamic>> pendingBookings = [
    {
      'name': 'John Doe',
      'event': 'Wedding Event',
      'date': '2025-03-15',
      'time': '6:00 PM - 10:00 PM',
      'guests': 150,
      'package': '2-Course Dinner',
      'amount': 'NPR 97,500',
      'phone': '+977 9876543210',
      'address': 'Kathmandu, Nepal',
    },
    {
      'name': 'Sarah Smith',
      'event': 'Birthday Party',
      'date': '2025-03-18',
      'time': '2:00 PM - 6:00 PM',
      'guests': 50,
      'package': 'Private Cooking',
      'amount': 'NPR 32,500',
      'phone': '+977 9812345678',
      'address': 'Lalitpur, Nepal',
    },
  ];

  List<Map<String, dynamic>> confirmedBookings = [
    {
      'name': 'Emma Wilson',
      'event': 'Anniversary Celebration',
      'date': '2025-03-22',
      'time': '7:00 PM - 11:00 PM',
      'guests': 100,
      'package': '2-Course Dinner',
      'amount': 'NPR 65,000',
      'phone': '+977 9801234567',
      'address': 'Bhaktapur, Nepal',
    },
  ];

  List<Map<String, dynamic>> completedBookings = [
    {
      'name': 'Lisa Anderson',
      'event': 'Retirement Party',
      'date': '2025-03-10',
      'time': '6:00 PM - 10:00 PM',
      'guests': 60,
      'package': 'Custom Menu',
      'amount': 'NPR 45,000',
      'phone': '+977 9823456789',
      'address': 'Pokhara, Nepal',
      'rating': 5.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _acceptBooking(Map<String, dynamic> booking) {
    setState(() {
      // Remove from pending bookings
      pendingBookings.removeWhere(
        (b) => b['name'] == booking['name'] && b['date'] == booking['date'],
      );

      // Add to confirmed bookings
      confirmedBookings.add(booking);

      // Switch to confirmed tab
      _tabController.animateTo(1);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    setState(() {
      // Remove from pending bookings
      pendingBookings.removeWhere(
        (b) => b['name'] == booking['name'] && b['date'] == booking['date'],
      );
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Cancelled'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _completeBooking(Map<String, dynamic> booking) {
    setState(() {
      // Remove from confirmed bookings
      confirmedBookings.removeWhere(
        (b) => b['name'] == booking['name'] && b['date'] == booking['date'],
      );

      // Add to completed bookings (without rating initially)
      completedBookings.add(booking);

      // Switch to completed tab
      _tabController.animateTo(2);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking marked as completed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking, String status) {
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
                _buildDetailRow(Icons.person, 'Customer', booking['name']),
                _buildDetailRow(Icons.event, 'Event Type', booking['event']),
                _buildDetailRow(Icons.calendar_today, 'Date', booking['date']),
                _buildDetailRow(Icons.access_time, 'Time', booking['time']),
                _buildDetailRow(
                  Icons.people,
                  'Guests',
                  '${booking['guests']} People',
                ),
                _buildDetailRow(
                  Icons.restaurant_menu,
                  'Package',
                  booking['package'],
                ),
                _buildDetailRow(Icons.phone, 'Phone', booking['phone']),
                _buildDetailRow(
                  Icons.location_on,
                  'Address',
                  booking['address'],
                ),
                const Divider(),
                _buildDetailRow(Icons.money, 'Total Amount', booking['amount']),
                if (booking['rating'] != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Rating: ${booking['rating']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                if (status == 'pending')
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
                if (status == 'confirmed') ...[
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
                      '${pendingBookings.length}',
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
                      '${confirmedBookings.length}',
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
                      '${completedBookings.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(pendingBookings, 'pending'),
          _buildBookingList(confirmedBookings, 'confirmed'),
          _buildBookingList(completedBookings, 'completed'),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Map<String, dynamic>> bookings, String status) {
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
        return _buildBookingCard(booking, status);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, String status) {
    Color statusColor = status == 'pending'
        ? Colors.orange
        : status == 'confirmed'
        ? Colors.green
        : Colors.blue;

    return GestureDetector(
      onTap: () => _showBookingDetails(booking, status),
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
                    booking['name'].toString()[0],
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
                        booking['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking['event'],
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
                    status.toUpperCase(),
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
                Text(booking['date'], style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking['time'],
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
                          '${booking['guests']} Guests',
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
                    booking['amount'],
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
            if (booking['rating'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('Rating: ${booking['rating']}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
