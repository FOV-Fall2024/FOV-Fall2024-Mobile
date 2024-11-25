abstract class IAttendanceRepository {
  Future<Map<String, dynamic>> checkIn(
      String qrCodeData, String userId, double latitude, double longitude);
}
