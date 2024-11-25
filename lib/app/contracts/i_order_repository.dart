import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/orderItem.dart';

abstract class IOrderRepository {
  Future<List<OrderItem>> getOrders();
  Future<OrderDetail> getOrderDetailById(String id);
  Future<String> confirmOrder(String id);
  Future<String> cancelOrder(String id);
  Future<String> cancelAddMore(String id);
  Future<String> refundOrder({
    required String orderId,
    required String orderDetailId,
    required int refundQuantity,
  });
}
