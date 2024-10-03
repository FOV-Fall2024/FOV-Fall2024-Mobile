import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftPage extends StatelessWidget {
  // Temporary attendance status
  final List<bool> attendanceStatus = [false, true, false, true, false, false, false];

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
            Text(
              'Request to Leave Early',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                },
                child: Text('Clock Out'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
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
              onTap: () {
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? Colors.lightGreen
                      : hasAttendance
                      ? Colors.green
                      : Colors.red.withOpacity(0.3),
                  border: Border.all(
                    color: isToday ? Colors.blue : (hasAttendance ? Colors.green : Colors.red),
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
}

extension DateComparison on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
