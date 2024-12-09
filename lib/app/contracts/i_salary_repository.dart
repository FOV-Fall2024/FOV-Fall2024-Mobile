import 'package:fov_fall2024_waiter_mobile_app/app/entities/salary_entity.dart';

abstract class ISalaryRepository {
  Future<EmployeeResponse> fetchSalaryForEmployee(String? chosenDate);
}
