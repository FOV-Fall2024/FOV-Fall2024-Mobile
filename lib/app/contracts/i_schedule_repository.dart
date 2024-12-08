import 'package:fov_fall2024_waiter_mobile_app/app/entities/schedule_entity.dart';

abstract class IScheduleRepository {
  Future<ScheduleResponse> getCurrentWeekSchedule();
}
