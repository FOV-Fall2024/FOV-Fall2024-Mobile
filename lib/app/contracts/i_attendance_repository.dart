import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';

abstract class IAttendanceRepository {
  Future<AttendanceResponse> fetchDailyAttendance();
  Future<Map<String, dynamic>> checkIn(
      String qrCodeData, String userId, double latitude, double longitude);
  Future<Map<String, dynamic>> checkOut(
      String shiftId, String date, double latitude, double longitude);
}
