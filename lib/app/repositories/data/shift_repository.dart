import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class ShiftRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/v1/Shift';

  Future<Map<String, dynamic>> getShifts() async {
    final url = Uri.parse(_baseUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await AuthRepository().getToken()}'
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return {'data': jsonDecode(response.body)};
      } else {
        return {
          'error': 'Failed to fetch shifts',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}
