import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_salary_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:fov_fall2024_waiter_mobile_app/app/entities/salary_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';

class SalaryRepository implements ISalaryRepository {
  final String baseUrl = "http://vktrng.ddns.net:8080/api/Salary";
  final authRepository = GetIt.I<IAuthRepository>();

  @override
  Future<EmployeeResponse> fetchSalaryForEmployee(String? chosenDate) async {
    final userId = await authRepository.getUserId();
    final url = Uri.parse(
        '$baseUrl/salary-restaurant?ChosenDate=$chosenDate&UserId=$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return EmployeeResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load salary information');
    }
  }
}
