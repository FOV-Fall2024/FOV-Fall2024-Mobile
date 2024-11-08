import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/payment_repository.dart';
import 'package:intl/intl.dart';

class OrderItemTile extends StatelessWidget {
  final OrderDetailItem item;

  const OrderItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        item.comboId != null
            ? item.thumbnail.toString()
            : item.image.toString(),
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      ),
      title: Text(
        item.comboId != null
            ? item.comboName.toString()
            : item.productName.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Status: ${item.status}'),
      trailing: Text('${formatCurrency(item.price * item.quantity)} VND'),
    );
  }
}

class OrderActions extends StatelessWidget {
  final OrderDetail orderDetail;
  final OrderRepository orderRepository;
  final String orderStatus;

  OrderActions({
    Key? key,
    required this.orderDetail,
    required this.orderRepository,
    required this.orderStatus,
  }) : super(key: key);

  final PaymentRepository paymentRepository = PaymentRepository();

  Future<void> _handleOrderAction(BuildContext context, String action) async {
    String response;
    String successMessage;
    String failureMessage;

    if (action == 'confirm') {
      response = await orderRepository.confirmOrder(orderDetail.orderId);
      successMessage = 'Order confirmed!';
      failureMessage = 'Cannot confirm order!';
      Navigator.pop(context, 1);
    } else if (action == 'cancel') {
      response = await orderRepository.cancelOrder(orderDetail.orderId);
      successMessage = 'Order cancelled!';
      failureMessage = 'Cannot cancel order!';
      Navigator.pop(context, 1);
    } else if (action == 'confirmPayment') {
      response = await paymentRepository.confirmPayByCash(orderDetail.orderId);
      successMessage = 'Payment confirmed!';
      failureMessage = 'Cannot confirm payment!';
      Navigator.pop(context, 1);
    } else {
      return; // No valid action provided
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(response != '500' ? successMessage : failureMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (orderStatus == "Prepare")
          _buildActionButton(
            context,
            'Cancel Order',
            Colors.red,
            () => _handleOrderAction(context, 'cancel'),
          ),
        if (orderStatus == "Prepare")
          _buildActionButton(
            context,
            'Confirm Order',
            Colors.green,
            () => _handleOrderAction(context, 'confirm'),
          ),
        if (orderStatus == "payment")
          _buildActionButton(
            context,
            'Confirm receive money from customer',
            Colors.blue,
            () => _handleOrderAction(context, 'confirmPayment'),
          ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

String formatCurrency(int value) {
  var formatter = NumberFormat.decimalPattern('vi_VN');
  return formatter.format(value);
}

List<OrderDetailItem> getAdditionalItems(OrderDetail orderDetail) {
  return orderDetail.orderDetails
      .where((item) => item.isAddMore == true)
      .toList();
}
