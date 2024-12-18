import 'dart:async';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_shift_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/shift_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/view_model/shift_view_model.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/storage_service.dart';
import 'package:get_it/get_it.dart';

enum AttendanceStatus {
  noSchedule,
  noShiftMatch,
  userIsCheckIn,
  userIsNotCheckIn
}

enum CheckoutStatus {
  noSchedule,
  noShiftMatch,
  userIsCheckOut,
  userIsNotCheckOut
}

class AttendanceShiftService {
  final shiftRepository = GetIt.I<IShiftRepository>();
  final attendanceRepository = GetIt.I<IAttendanceRepository>();
  final storageService = GetIt.I<IStorageService>();
  String _currentShiftId = "currentShiftId";

  Future<AttendanceStatus> isUserCheckIn() async {
    try {
      List<Shifts> shifts = await shiftRepository.getShifts();
      AttendanceResponse attendanceResponse =
          await attendanceRepository.fetchDailyAttendance();
      DateTime now = DateTime.now();
      Shifts? currentShift = _findCurrentShift(shifts, now);
      String currentShiftId = currentShift?.id ?? '';
      await storageService.write(_currentShiftId, currentShiftId);
      //if no shift matches the current time
      if (currentShift == null) {
        return AttendanceStatus.noSchedule;
      }
      var attendance = attendanceResponse.results.firstWhere(
        (a) => a.waiterSchedule.shift.shiftId == currentShift.id,
        //create dummy for no match case
        orElse: () => Attendance(
            id: "",
            checkInTime: null,
            checkOutTime: null,
            waiterSchedule: WaiterSchedule(
                id: "",
                employee: Employees(
                    employeeId: "",
                    employeeCode: "",
                    employeeName: "",
                    waiterScheduleId: ""),
                shift: Shift(shiftId: "", shiftName: ""),
                isCheckIn: false),
            createdDate: DateTime.now()),
      );
      if (attendance.id.isEmpty) {
        return AttendanceStatus.noSchedule;
      } else if (attendance.waiterSchedule.isCheckIn == true) {
        return AttendanceStatus.userIsCheckIn;
      } else if (attendance.waiterSchedule.isCheckIn == false) {
        return AttendanceStatus.userIsNotCheckIn;
      } else {
        return AttendanceStatus.noShiftMatch;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to process attendance and shift data.');
    }
  }

  Future<CheckoutStatus> isUserCheckOut() async {
    try {
      List<Shifts> shifts = await shiftRepository.getShifts();
      AttendanceResponse attendanceResponse =
          await attendanceRepository.fetchDailyAttendance();
      DateTime now = DateTime.now();
      Shifts? currentShift = _findCurrentShift(shifts, now);

      //if no shift matches the current time
      if (currentShift == null) {
        return CheckoutStatus.noSchedule;
      }
      var attendance = attendanceResponse.results.firstWhere(
        (a) => a.waiterSchedule.shift.shiftId == currentShift.id,
        //create dummy for no match case
        orElse: () => Attendance(
            id: "",
            checkInTime: null,
            checkOutTime: null,
            waiterSchedule: WaiterSchedule(
                id: "",
                employee: Employees(
                    employeeId: "",
                    employeeCode: "",
                    employeeName: "",
                    waiterScheduleId: ""),
                shift: Shift(shiftId: "", shiftName: ""),
                isCheckIn: false),
            createdDate: DateTime.now()),
      );
      if (attendance.id.isEmpty) {
        return CheckoutStatus.noSchedule;
      } else if (attendance.checkOutTime != null) {
        return CheckoutStatus.userIsCheckOut;
      } else if (attendance.checkOutTime == null) {
        return CheckoutStatus.userIsNotCheckOut;
      } else {
        return CheckoutStatus.noShiftMatch;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to process attendance and shift data.');
    }
  }

  Shifts? _findCurrentShift(List<Shifts> shifts, DateTime now) {
    for (Shifts shift in shifts) {
      DateTime startTime = _combineDateAndTime(now, shift.startTime);
      DateTime endTime = _combineDateAndTime(now, shift.endTime);
      // if (endTime.isBefore(startTime)) {
      //   endTime = endTime.add(const Duration(days: 1)); // End time is next day
      // }
      if (now.isAfter(startTime.subtract(Duration(minutes: 5))) &&
          now.isBefore(endTime)) {
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
