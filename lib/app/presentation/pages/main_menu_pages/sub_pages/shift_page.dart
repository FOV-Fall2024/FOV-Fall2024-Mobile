import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftPage extends StatelessWidget {
  // Temporary attendance status
  final List<bool> attendanceStatus = [
    false,
    true,
    false,
    true,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week Shift',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildWeekCalendar(),
            Divider(height: 40),
            _buildTodayShiftSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        bool isToday = day.isSameDay(now);
        bool hasAttendance = attendanceStatus[index];

        return Column(
          children: [
            Text(
              DateFormat.E().format(day),
              style: TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? Colors.lightGreen
                      : hasAttendance
                          ? Colors.green
                          : Colors.red.withOpacity(0.3),
                  border: Border.all(
                    color: isToday
                        ? Colors.blue
                        : (hasAttendance ? Colors.green : Colors.red),
                    width: isToday ? 4 : 2,
                  ),
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    DateFormat.d().format(day),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTodayShiftSection() {
    //Placeholder, need api to get details
    String shiftStartTime = '7:00';
    String shiftEndTime = '17:00';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today Shift',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      shiftStartTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 15),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      height: 30,
                      width: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'End',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      shiftEndTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

extension DateComparison on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
