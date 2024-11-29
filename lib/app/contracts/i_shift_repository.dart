import 'package:fov_fall2024_waiter_mobile_app/app/entities/shift_entity.dart';

abstract class IShiftRepository {
  Future<List<Shifts>> getShifts();
}
