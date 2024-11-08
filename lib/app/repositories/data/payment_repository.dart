import 'package:http/http.dart' as http;
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';

class PaymentRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Payment';
  final AuthRepository authRepository = AuthRepository();

  //Confirm pay by cash
  Future<String> confirmPayByCash(String id) async {
    final url = Uri.parse('$_baseUrl/$id/confirm');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // throw Exception('Failed to confirm pay by cash: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
