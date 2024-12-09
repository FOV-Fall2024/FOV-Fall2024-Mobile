import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/orderItem.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class OrderRepository implements IOrderRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Order';
  final AuthRepository authRepository = AuthRepository();

  //Get all orders
  @override
  Future<List<OrderItem>> getOrders() async {
    final url = Uri.parse(_baseUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}',
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic>? results = data['results'];
        // Map the results to a list of OrderItem objects
        if (results != null) {
          List<OrderItem> orders =
              results.map((item) => OrderItem.fromJson(item)).toList();

          const List<String> statusOrder = [
            'Prepare',
            'Payment',
            'Cook',
            'Service',
            'Finish',
            'Canceled'
          ];
          // Sort orders based on the predefined status order
          orders.sort((a, b) {
            int aIndex = statusOrder.indexOf(a.orderStatus);
            int bIndex = statusOrder.indexOf(b.orderStatus);
            return aIndex.compareTo(bIndex);
          });

          return orders;
        } else
          return [];
      } else if (response.statusCode == 401) {
        throw 'You do not have access to this page';
      } else {
        throw 'Failed to fetch orders: ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  //View order details
  @override
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
  @override
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

  //Cancel order
  @override
  Future<String> cancelOrder(String id) async {
    final url = Uri.parse('$_baseUrl/$id/cancel');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // throw Exception('Failed to cancel order: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //Cancel order
  @override
  Future<String> cancelAddMore(String id) async {
    final url = Uri.parse('$_baseUrl/$id/cancel-add-more');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // throw Exception('Failed to cancel add more: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //Refund item in order
  @override
  Future<String> refundOrder({
    required String orderId,
    required String orderDetailId,
    required int refundQuantity,
  }) async {
    final url = Uri.parse(
        '$_baseUrl/$orderId/refund?orderDetailId=$orderDetailId&refundQuantity=$refundQuantity');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}',
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // throw Exception('Failed to refund order: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //Serve cooked food tranfer from headchef
  //Also used to serve refundable dish to customer
  @override
  Future<String> serveDish(
      {required String orderId, required String orderDetailsId}) async {
    final url = '$_baseUrl/$orderId/serve?orderDetailsId=$orderDetailsId';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}',
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
