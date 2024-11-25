import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_schedule_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class ScheduleRepository implements IScheduleRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/v1/Schedule';

  Future<Map<String, dynamic>> getScheduleOfCurrentWeek() async {
    final employeeId = await AuthRepository().getUserId();
    final token = await AuthRepository().getToken();
    final url = Uri.parse('$_baseUrl/employee?EmployeeId=$employeeId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return {'data': jsonDecode(response.body)};
      } else {
        return {
          'error': 'Failed to fetch schedules',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}
