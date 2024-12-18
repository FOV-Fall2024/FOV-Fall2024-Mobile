import 'package:cron/cron.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_shift_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/shift_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'location_service.dart';

class ShiftCronService {
  final shiftRepository = GetIt.I<IShiftRepository>();
  final attendanceRepository = GetIt.I<IAttendanceRepository>();
  final locationService = LocationService();
  final cron = Cron();

  void scheduleShiftCheck() {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      print("1 min has pass since last check");
      await checkAndProcessShifts();
    });
  }

  Future<void> checkAndProcessShifts() async {
    try {
      List<Shifts> shifts = await shiftRepository.getShifts();
      DateTime now = DateTime.now();

      for (var shift in shifts) {
        DateTime endTime = _combineDateAndTime(now, shift.endTime);
        if (_isMatchingTime(now, endTime)) {
          print('Checking out users for shift ${shift.id} at $endTime');
          await _checkOutShift(shift);
        }
      }
    } catch (e) {
      print('Error during shift check: $e');
    }
  }

  Future<void> _checkOutShift(Shifts shift) async {
    try {
      DateTime now = DateTime.now();
      String date = '${now.year}-${now.month}-${now.day}';

      Position position = await locationService.getCurrentPosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      var response = await attendanceRepository.checkOut(
        shift.id,
        date,
        latitude,
        longitude,
      );

      if (response['success'] == true) {
        print('Successfully checked out shift ${shift.id}');
      } else {
        print('Failed to check out shift ${shift.id}: ${response['error']}');
      }
    } catch (e) {
      print('Error during checkout for shift ${shift.id}: $e');
    }
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

  bool _isMatchingTime(DateTime now, DateTime endTime) {
    return now.difference(endTime).inSeconds.abs() < 60;
  }
}
