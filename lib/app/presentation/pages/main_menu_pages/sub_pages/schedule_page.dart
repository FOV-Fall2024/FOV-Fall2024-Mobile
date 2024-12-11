import 'dart:ui';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_salary_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/salary_entity.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_shift_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_schedule_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/shift_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/view_model/shift_view_model.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/background_image_by_time.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/schedule_pages/payroll_detail_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/schedule_entity.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<ScheduleResponse> _scheduleFuture;
  final scheduleRepository = GetIt.I<IScheduleRepository>();
  final salaryRepository = GetIt.I<ISalaryRepository>();
  final attendanceRepository = GetIt.I<IAttendanceRepository>();
  final shiftRepository = GetIt.I<IShiftRepository>();
  final authRepository = GetIt.I<IAuthRepository>();

  DateTime _selectedDate = DateTime.now();
  late Future<EmployeeResponse> _salaryFuture;
  @override
  void initState() {
    super.initState();
    _scheduleFuture = scheduleRepository.getCurrentWeekSchedule();
    _updateSalaryFuture();
  }

  void _updateSalaryFuture() {
    String formattedDate = DateFormat('yyyy-MM').format(_selectedDate);
    _salaryFuture = salaryRepository.fetchSalaryForEmployee(formattedDate);
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + offset,
      );
      _updateSalaryFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundImage()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          SingleChildScrollView(
            // Wrap the Column in SingleChildScrollView
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
                FutureBuilder<ScheduleResponse>(
                  future: _scheduleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return _buildWeekCalendar(snapshot.data!.results);
                    } else {
                      return Text('No data available.');
                    }
                  },
                ),
                Divider(height: 40),
                FutureBuilder<ScheduleResponse>(
                  future: _scheduleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return _buildTodayShiftSection();
                    } else {
                      return Text('No data available.');
                    }
                  },
                ),
                Divider(height: 40),
                _buildPayrollSection(),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar(List<ScheduleItem> scheduleItems) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        bool isToday = day.isSameDay(now);
        ScheduleItem? matchingItem = scheduleItems.firstWhere(
          (item) => DateTime.parse(item.date).isSameDay(day),
          orElse: () => ScheduleItem(
            id: '',
            shift: Shift(shiftId: '', shiftName: 'No Shift'),
            date: '',
            createdDate: '',
          ),
        );

        bool hasAttendance = matchingItem.id.isNotEmpty;

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
                  color: hasAttendance
                      ? Colors.lightGreen
                      : Colors.grey.withOpacity(0.3),
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
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        attendanceRepository.fetchDailyAttendance(),
        shiftRepository.getShifts(),
        authRepository.getUserId(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final attendance = snapshot.data![0] as AttendanceResponse;
          final shifts = snapshot.data![1] as List<Shifts>;
          final userId = snapshot.data![2] as String;
          shifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          // get only current user
          final userAttendance = attendance.results.where((att) {
            return att.waiterSchedule.employee.employeeId == userId;
          }).toList();
          final attendanceMap = {
            for (var att in userAttendance)
              att.waiterSchedule.shift.shiftId: att
          };
          var timeFormat = DateFormat("HH:mm");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Shifts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: shifts.map((shift) {
                  final matchingAttendance = attendanceMap[shift.id] ??
                      Attendance(
                        id: "",
                        checkInTime: null,
                        checkOutTime: null,
                        waiterSchedule: WaiterSchedule(
                          id: "",
                          employee: Employees(
                            employeeId: "",
                            employeeCode: "",
                            employeeName: "",
                            waiterScheduleId: "",
                          ),
                          shift: Shift(shiftId: "", shiftName: ""),
                          isCheckIn: false,
                        ),
                        createdDate: DateTime.now(),
                      );
                  Color shiftColor = _determineShiftColor(matchingAttendance);

                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: shiftColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          shift.shiftName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${timeFormat.format(DateTime.parse(shift.startTime))} - ${timeFormat.format(DateTime.parse(shift.endTime))}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                  );
                }).toList(),
              ),
            ],
          );
        } else {
          return Text('No data available.');
        }
      },
    );
  }

  Widget _buildPayrollSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payroll by Period',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
        FutureBuilder<EmployeeResponse>(
          future: _salaryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
              final employee = snapshot.data!.results.first;
              final salary = employee.salary;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSalaryRow('Employee Name:', employee.employeeName),
                      _buildSalaryRow(
                          'Total Shifts:', salary.totalShifts.toString()),
                      _buildSalaryRow('Total Hours Worked:',
                          salary.totalHoursWorked.toString()),
                      _buildSalaryRow(
                        'Penalty:',
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND')
                            .format(salary.penalty),
                      ),
                      _buildSalaryRow(
                        'Total Salaries:',
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND')
                            .format(salary.totalSalaries),
                        bold: true,
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PayrollDetailPage(
                                selectedDate: _selectedDate,
                              ),
                            ),
                          );
                        },
                        child: Text('View Attendance Details'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text('No payroll data available.');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSalaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Color _determineShiftColor(Attendance attendance) {
    if (attendance.id.isEmpty) {
      return Colors.grey;
    } else if (attendance.waiterSchedule.isCheckIn) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

extension DateComparison on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
