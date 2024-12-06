import 'dart:async';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_shift_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/shift_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';
import 'package:get_it/get_it.dart';

class AttendanceShiftService {
  final shiftRepository = GetIt.I<IShiftRepository>();
  final attendanceRepository = GetIt.I<IAttendanceRepository>();

  Future<bool> isUserCheckIn() async {
    try {
      List<Shifts> shifts = await shiftRepository.getShifts();
      AttendanceResponse attendanceResponse =
          await attendanceRepository.fetchAttendance();
      DateTime now = DateTime.now();
      Shifts? currentShift = _findCurrentShift(shifts, now);
      //if no shift match current shift
      if (currentShift == null) {
        return false;
      }
      //search for current shift attendance status
      for (Attendance attendance in attendanceResponse.results) {
        if (attendance.checkInTime != null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to process attendance and shift data.');
    }
  }

  Shifts? _findCurrentShift(List<Shifts> shifts, DateTime now) {
    for (Shifts shift in shifts) {
      DateTime startTime = _combineDateAndTime(now, shift.startTime);
      DateTime endTime = _combineDateAndTime(now, shift.endTime);
      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }
      if (now.isAfter(startTime.subtract(const Duration(minutes: 30))) &&
          now.isBefore(endTime.add(const Duration(minutes: 30)))) {
        return shift;
      }
    }
    return null;
  }

  DateTime _combineDateAndTime(DateTime date, String time) {
    List<String> timeParts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );
  }
}
