import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/orderItem.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Order';
  final AuthRepository authRepository = AuthRepository();

  //Get all orders
  Future<List<OrderItem>> getOrders() async {
    final url = Uri.parse(_baseUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<OrderItem> orders =
            data.map((item) => OrderItem.fromJson(item)).toList();

        const List<String> statusOrder = [
          'Prepare',
          'Payment',
          'Cook',
          'Service',
          'Finish',
          'Canceled'
        ];

        orders.sort((a, b) {
          int aIndex = statusOrder.indexOf(a.orderStatus);
          int bIndex = statusOrder.indexOf(b.orderStatus);
          return aIndex.compareTo(bIndex);
        });

        return orders;
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //View order details
  Future<OrderDetail> getOrderDetailById(String id) async {
    final url = Uri.parse('$_baseUrl/$id/details');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OrderDetail.fromJson(data);
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //Confirm order and transfer to headchef
  Future<String> confirmOrder(String id) async {
    final url = Uri.parse('$_baseUrl/$id/cook');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // throw Exception('Failed to confirm order: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //Confirm order and transfer to headchef
  Future<String> confirmPayment(String id) async {
    final url = Uri.parse('$_baseUrl/$id/cook');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // throw Exception('Failed to confirm order: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
