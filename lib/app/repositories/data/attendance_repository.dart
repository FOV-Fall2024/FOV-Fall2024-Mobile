import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class AttendanceRepository implements IAttendanceRepository {
  final authRepository = AuthRepository();
  final String baseUrl = "http://vktrng.ddns.net:8080/api/Attendance";

  @override
  Future<AttendanceResponse> fetchDailyAttendance() async {
    final url = Uri.parse('$baseUrl/daily');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return AttendanceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  @override
  Future<Map<String, dynamic>> checkIn(String qrCodeData, String userId,
      double latitude, double longitude) async {
    Uri url = Uri.parse(qrCodeData);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'userId': userId,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    });
    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        bool isSuccess = responseData['statusCode'] == 200 &&
            responseData['reasonStatusCode'] == "Success";

        return {
          'success': isSuccess,
          'data': responseData,
          'message': responseData['message'] ?? '',
          'statusCode': response.statusCode
        };
      } else {
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decodedBody);
        String errorMessage =
            responseData['message'] ?? 'Unknown error occurred';
        return {
          'success': false,
          'error': errorMessage,
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred: $e',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> checkOut(
      String shiftId, String date, double latitude, double longitude) async {
    try {
      final url = Uri.parse('$baseUrl/checkout?shiftId=$shiftId&date=$date');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await authRepository.getToken()}'
      };
      final body = jsonEncode({'latitude': latitude, 'longitude': longitude});
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        bool isSuccess = responseData['statusCode'] == 200 &&
            responseData['reasonStatusCode'] == "Success";

        return {
          'success': isSuccess,
          'data': responseData,
          'message': responseData['message'] ?? '',
          'statusCode': response.statusCode
        };
      } else {
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decodedBody);
        String errorMessage =
            responseData['message'] ?? 'Unknown error occurred';
        return {
          'success': false,
          'error': errorMessage,
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred: $e',
      };
    }
  }
}
