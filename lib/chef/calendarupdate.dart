import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // Store availability data: date -> {isAvailable, timeSlots, maxBookings}
  Map<String, Map<String, dynamic>> availabilityData = {
    '2025-03-15': {
      'isAvailable': true,
      'timeSlots': ['10:00 AM - 2:00 PM', '6:00 PM - 10:00 PM'],
      'maxBookings': 2,
      'notes': 'Available for events',
    },
    '2025-03-18': {
      'isAvailable': true,
      'timeSlots': ['2:00 PM - 6:00 PM'],
      'maxBookings': 1,
      'notes': 'Afternoon only',
    },
    '2025-03-20': {
      'isAvailable': false,
      'timeSlots': [],
      'maxBookings': 0,
      'notes': 'Personal day off',
    },
  };

  // Predefined time slots
  final List<String> predefinedTimeSlots = [
    '8:00 AM - 12:00 PM',
    '12:00 PM - 4:00 PM',
    '4:00 PM - 8:00 PM',
    '6:00 PM - 10:00 PM',
    '10:00 AM - 2:00 PM',
    '2:00 PM - 6:00 PM',
    'Full Day (8:00 AM - 8:00 PM)',
  ];

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isDateAvailable(DateTime date) {
    String key = _formatDateKey(date);
    return availabilityData[key]?['isAvailable'] ?? false;
  }

  bool _isDateUnavailable(DateTime date) {
    String key = _formatDateKey(date);
    return availabilityData.containsKey(key) &&
        availabilityData[key]?['isAvailable'] == false;
  }

  void _showAvailabilityDialog(DateTime date) {
    String dateKey = _formatDateKey(date);
    Map<String, dynamic>? existingData = availabilityData[dateKey];

    bool isAvailable = existingData?['isAvailable'] ?? true;
    List<String> selectedSlots = List<String>.from(
      existingData?['timeSlots'] ?? [],
    );
    int maxBookings = existingData?['maxBookings'] ?? 1;
    TextEditingController notesController = TextEditingController(
      text: existingData?['notes'] ?? '',
    );
    TextEditingController customSlotController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 700, maxWidth: 400),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Set Availability',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDisplayDate(date),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(height: 24),

                  // Availability Toggle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? const Color(0xFF8BC34A).withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isAvailable
                            ? const Color(0xFF8BC34A)
                            : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Icon(
                                isAvailable ? Icons.check_circle : Icons.cancel,
                                color: isAvailable
                                    ? const Color(0xFF8BC34A)
                                    : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isAvailable ? 'Available' : 'Unavailable',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isAvailable,
                          activeThumbColor: const Color(0xFF8BC34A),
                          onChanged: (value) {
                            setDialogState(() {
                              isAvailable = value;
                              if (!value) {
                                selectedSlots.clear();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  if (isAvailable) ...[
                    const SizedBox(height: 20),

                    // Time Slots Section
                    const Text(
                      'Available Time Slots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Predefined time slots
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: predefinedTimeSlots.map((slot) {
                        bool isSelected = selectedSlots.contains(slot);
                        return FilterChip(
                          label: Text(
                            slot,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedSlots.add(slot);
                              } else {
                                selectedSlots.remove(slot);
                              }
                            });
                          },
                          selectedColor: const Color(0xFF8BC34A),
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Custom time slot
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: customSlotController,
                            decoration: const InputDecoration(
                              labelText: 'Custom Time',
                              hintText: '3:00 PM - 7:00 PM',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time, size: 20),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (customSlotController.text.isNotEmpty) {
                              setDialogState(() {
                                selectedSlots.add(customSlotController.text);
                                customSlotController.clear();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            padding: const EdgeInsets.all(12),
                            minimumSize: const Size(48, 48),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),

                    // Display selected slots
                    if (selectedSlots.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Selected Time Slots:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...selectedSlots.map(
                        (slot) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8E6B8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  slot,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setDialogState(() {
                                    selectedSlots.remove(slot);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Max bookings
                    const Text(
                      'Maximum Bookings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: maxBookings > 1
                              ? () {
                                  setDialogState(() {
                                    maxBookings--;
                                  });
                                }
                              : null,
                          padding: const EdgeInsets.all(8),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$maxBookings',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setDialogState(() {
                              maxBookings++;
                            });
                          },
                          padding: const EdgeInsets.all(8),
                        ),
                        const SizedBox(width: 4),
                        const Flexible(
                          child: Text(
                            'booking(s) per day',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Notes
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Add any special notes...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note, size: 20),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      if (existingData != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                availabilityData.remove(dateKey);
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Availability cleared'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      if (existingData != null) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!isAvailable || selectedSlots.isNotEmpty) {
                              setState(() {
                                availabilityData[dateKey] = {
                                  'isAvailable': isAvailable,
                                  'timeSlots': selectedSlots,
                                  'maxBookings': maxBookings,
                                  'notes': notesController.text,
                                };
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isAvailable
                                        ? 'Availability updated'
                                        : 'Marked as unavailable',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select at least one time slot',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
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

  String _formatDisplayDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
          'Availability Calendar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to use'),
                  content: const Text(
                    'Tap on any date to set your availability:\n\n'
                    '• Toggle Available/Unavailable\n'
                    '• Select time slots\n'
                    '• Set max bookings per day\n'
                    '• Add notes if needed\n\n'
                    'Green border = Available\n'
                    'Red border = Unavailable',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Calendar Widget
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Month/Year Selector with Year Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              if (selectedMonth == 1) {
                                selectedMonth = 12;
                                selectedYear--;
                              } else {
                                selectedMonth--;
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            _showYearPicker();
                          },
                          child: Row(
                            children: [
                              Text(
                                '${_getMonthName(selectedMonth)} $selectedYear',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down, size: 20),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              if (selectedMonth == 12) {
                                selectedMonth = 1;
                                selectedYear++;
                              } else {
                                selectedMonth++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Weekday Headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                          .map(
                            (day) => SizedBox(
                              width: 40,
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),

                    // Calendar Grid
                    _buildCalendarGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Legend
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Legend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildLegendItem(
                          const Color(0xFF8BC34A),
                          'Available',
                          Icons.check_circle,
                        ),
                        const SizedBox(width: 20),
                        _buildLegendItem(
                          Colors.red,
                          'Unavailable',
                          Icons.cancel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Upcoming Events Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3D9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Availability Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryStats(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSummaryStats() {
    int availableDays = availabilityData.values
        .where((data) => data['isAvailable'] == true)
        .length;
    int unavailableDays = availabilityData.values
        .where((data) => data['isAvailable'] == false)
        .length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          '$availableDays',
          'Available Days',
          const Color(0xFF8BC34A),
        ),
        _buildStatItem('$unavailableDays', 'Blocked Days', Colors.red),
        _buildStatItem(
          '${availableDays + unavailableDays}',
          'Total Set',
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
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
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showYearPicker() {
    int currentYear = DateTime.now().year;
    int startYear = currentYear;
    int endYear = currentYear + 5;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Year'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: endYear - startYear + 1,
            itemBuilder: (context, index) {
              int year = startYear + index;
              bool isSelected = year == selectedYear;

              return ListTile(
                title: Text(
                  '$year',
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? const Color(0xFF8BC34A) : Colors.black,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: const Color(0xFFB8E6B8).withValues(alpha: 0.3),
                onTap: () {
                  setState(() {
                    selectedYear = year;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(selectedYear, selectedMonth, 1);
    final lastDay = DateTime(selectedYear, selectedMonth + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    final daysInMonth = lastDay.day;

    List<Widget> dayWidgets = [];

    // Add empty spaces for days before the first day
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    // Add day numbers
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedYear, selectedMonth, day);
      final isSelected =
          date.day == selectedDate.day &&
          date.month == selectedDate.month &&
          date.year == selectedDate.year;
      final isAvailable = _isDateAvailable(date);
      final isUnavailable = _isDateUnavailable(date);
      final isPast = date.isBefore(
        DateTime.now().subtract(const Duration(days: 1)),
      );

      dayWidgets.add(
        InkWell(
          onTap: isPast
              ? null
              : () {
                  setState(() {
                    selectedDate = date;
                  });
                  _showAvailabilityDialog(date);
                },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF8BC34A)
                  : isPast
                  ? Colors.grey[200]
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: isAvailable
                  ? Border.all(color: const Color(0xFF8BC34A), width: 2)
                  : isUnavailable
                  ? Border.all(color: Colors.red, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isPast
                          ? Colors.grey
                          : Colors.black,
                      fontWeight: (isAvailable || isUnavailable)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (isAvailable || isUnavailable)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFF8BC34A)
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
