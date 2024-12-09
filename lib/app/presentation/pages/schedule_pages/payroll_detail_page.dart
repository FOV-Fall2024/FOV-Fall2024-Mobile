import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get_it/get_it.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_salary_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/salary_entity.dart';

class PayrollDetailPage extends StatefulWidget {
  final DateTime selectedDate;

  PayrollDetailPage({
    required this.selectedDate,
  });

  @override
  _PayrollDetailPageState createState() => _PayrollDetailPageState();
}

class _PayrollDetailPageState extends State<PayrollDetailPage> {
  late DateTime _focusedDate;
  late Map<DateTime, List<AttendanceDetails>> _groupedAttendance;
  final _salaryRepository = GetIt.I<ISalaryRepository>();
  bool _isLoading = true;
  String? _error;
  List<AttendanceDetails> _attendanceDetails = [];

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.selectedDate;
    _fetchAttendanceDetails();
  }

  Future<void> _fetchAttendanceDetails() async {
    try {
      String formattedDate = DateFormat('yyyy-MM').format(_focusedDate);
      final response =
          await _salaryRepository.fetchSalaryForEmployee(formattedDate);
      final attendanceDetails =
          response.results.first.salary.attendanceDetailsDtos;
      setState(() {
        _attendanceDetails = attendanceDetails;
      });

      _groupAttendanceDetails();
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _groupAttendanceDetails() {
    _groupedAttendance = {};
    for (var detail in _attendanceDetails) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(detail.date);
      if (!_groupedAttendance.containsKey(date)) {
        _groupedAttendance[date] = [];
      }
      _groupedAttendance[date]!.add(detail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                  children: [
                    TableCalendar(
                      focusedDay: _focusedDate,
                      firstDay: DateTime(
                          _focusedDate.year, _focusedDate.month - 1, 1),
                      lastDay: DateTime(
                          _focusedDate.year, _focusedDate.month + 1, 0),
                      calendarFormat: CalendarFormat.month,
                      eventLoader: (day) => _groupedAttendance[day] ?? [],
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _focusedDate = focusedDay;
                        });
                        _showAttendanceDetails(selectedDay);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Tap a date to view attendance details.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void _showAttendanceDetails(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    List<AttendanceDetails> details = _groupedAttendance[normalizedDate] ?? [];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Attendance Details for ${DateFormat.yMMMd().format(normalizedDate)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(),
              if (details.isEmpty)
                Text(
                  'No attendance records for this date.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              else
                ...details.map((detail) {
                  return ListTile(
                    title: Text(detail.shiftName),
                    subtitle: Text(
                      'Check-In: ${detail.checkInTime}\nCheck-Out: ${detail.checkOutTime}',
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }
}
