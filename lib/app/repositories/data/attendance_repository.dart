import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class AttendanceRepository implements IAttendanceRepository {
  final authRepository = AuthRepository();

  Future<Map<String, dynamic>> checkIn(String qrCodeData, String userId,
      double latitude, double longitude) async {
    Uri scannedUri = Uri.parse(qrCodeData);
    Map<String, String> updateQueryParams = Map.from(scannedUri.queryParameters)
      ..addAll({
        'userId': userId,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });
    Uri updatedUri = scannedUri.replace(queryParameters: updateQueryParams);

    try {
      final response = await http.post(updatedUri);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Infer success based on the response structure
        bool isSuccess = responseData['statusCode'] == 200 &&
            responseData['reasonStatusCode'] == "Success";

        return {
          'success': isSuccess,
          'data': responseData,
          'message': responseData['message'] ?? '',
          'statusCode': response.statusCode
        };
      } else {
        // Parse the error message if available
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
