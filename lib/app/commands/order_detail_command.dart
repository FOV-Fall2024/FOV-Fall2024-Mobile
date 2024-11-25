import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_payment_repository.dart';

Future<OrderDetail> fetchOrderDetail({
  required String orderId,
  required IOrderRepository orderRepository,
}) async {
  return await orderRepository.getOrderDetailById(orderId);
}

Future<String> handleOrderAction({
  required String orderId,
  required String action,
  required IOrderRepository orderRepository,
  required IPaymentRepository paymentRepository,
}) async {
  switch (action) {
    case 'confirm':
      return await orderRepository.confirmOrder(orderId);
    case 'cancel':
      return await orderRepository.cancelOrder(orderId);
    case 'cancelAddMore':
      return await orderRepository.cancelAddMore(orderId);
    case 'confirmPayment':
      return await paymentRepository.confirmPayByCash(orderId);
    default:
      throw ArgumentError('Invalid action: $action');
  }
}
