import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_schedule_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:fov_fall2024_waiter_mobile_app/app/entities/schedule_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:intl/intl.dart';

class ScheduleRepository implements IScheduleRepository {
  final String baseUrl = 'http://vktrng.ddns.net:8080/api/Schedule';
  @override
  Future<ScheduleResponse> getCurrentWeekSchedule() async {
    try {
      final authRepository = GetIt.I<IAuthRepository>();
      var today = DateFormat("yyyy-MM-dd").format(DateTime.now());
      var url = Uri.parse('$baseUrl/employee?SelectedDate=$today');
      Map<String, String> headers = {
        'Authorization': 'Bearer ${await authRepository.getToken()}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return ScheduleResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load schedule: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
