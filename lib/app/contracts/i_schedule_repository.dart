abstract class IScheduleRepository {
  Future<Map<String, dynamic>> getScheduleOfCurrentWeek();
}
