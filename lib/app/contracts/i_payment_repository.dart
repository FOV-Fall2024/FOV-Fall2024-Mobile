import 'package:fov_fall2024_waiter_mobile_app/app/entities/paymentItem.dart';

abstract class IPaymentRepository {
  Future<List<PaymentItem>> getPayment(String orderId);
  Future<String> confirmPayByCash(String id);
}
