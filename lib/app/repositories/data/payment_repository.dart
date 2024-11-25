import 'dart:convert';

import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_payment_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/paymentItem.dart';
import 'package:http/http.dart' as http;
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';

class PaymentRepository implements IPaymentRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Payment';
  final AuthRepository authRepository = AuthRepository();

  //Get all payment
  Future<List<PaymentItem>> getPayment(String orderId) async {
    final url = Uri.parse('$_baseUrl?OrderId=$orderId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<PaymentItem> payments =
            data.map((item) => PaymentItem.fromJson(item)).toList();
        return payments;
      } else {
        throw Exception('Failed to fetch payments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

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
