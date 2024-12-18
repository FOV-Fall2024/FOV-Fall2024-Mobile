import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_payment_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/paymentItem.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/order_page.component.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/payment_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/order_page.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class OrderItemTile extends StatelessWidget {
  final String orderId;
  final String orderStatus;
  final OrderDetailItem item;
  final orderRepository = GetIt.I<IOrderRepository>();
  final VoidCallback onDishServed;

  OrderItemTile(
      {Key? key,
      required this.orderId,
      required this.orderStatus,
      required this.item,
      required this.onDishServed})
      : super(key: key);
  Future<void> _serveCookedDishToCustomer(OrderDetailItem item) async {
    try {
      String response;
      response = await orderRepository.serveDish(
          orderId: orderId, orderDetailsId: item.id);
      print('Cooked dish served: $response');
      onDishServed();
    } catch (e) {
      print('An error occurred while serving the dish: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                item.status,
                style: TextStyle(
                  color: getStatusColor(item.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  item.comboId != null
                      ? item.thumbnail.toString()
                      : item.image.toString(),
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 50);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.comboId != null
                            ? item.comboName.toString()
                            : item.productName.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${item.quantity - item.refundQuantity}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (item.note.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Note: ${item.note}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Divider(),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${formatCurrency(item.price * (item.quantity - item.refundQuantity))} VND',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if ((orderStatus == 'Cook' || orderStatus == 'Cooked') &&
                item.status == 'Cooked')
              Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  onPressed: () async {
                    await _serveCookedDishToCustomer(item);
                  },
                  child: const Text('Serve dish'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OrderActions extends StatelessWidget {
  final OrderDetail orderDetail;
  final OrderRepository orderRepository;
  final PaymentRepository paymentRepository = PaymentRepository();
  final String orderStatus;
  bool isButtonPressed = false;

  OrderActions({
    Key? key,
    required this.orderDetail,
    required this.orderRepository,
    required this.orderStatus,
  }) : super(key: key);

  Future<void> _handleOrderAction(BuildContext context, String action) async {
    String response;
    String successMessage;
    String failureMessage;
    //Confirm order to send to headchef
    if (action == 'confirm') {
      response = await orderRepository.confirmOrder(orderDetail.orderId);
      successMessage = 'Order confirmed!';
      failureMessage = 'Cannot confirm order!';
      Navigator.pop(context, 1);
      isButtonPressed = true;
    }
    //Cancel order for customer to re-ordering
    else if (action == 'cancel') {
      response = await orderRepository.cancelOrder(orderDetail.orderId);
      successMessage = 'Order cancelled!';
      failureMessage = 'Cannot cancel order!';
      Navigator.pop(context, 1);
      isButtonPressed = true;
    }
    //Cancel add more order
    else if (action == 'cancelAddMore') {
      response = await orderRepository.cancelAddMore(orderDetail.orderId);
      successMessage = 'Order cancelled!';
      failureMessage = 'Cannot cancel order!';
      Navigator.pop(context, 1);
      isButtonPressed = true;
    }
    //Confirm payment by cash
    else if (action == 'confirmPayment') {
      response = await paymentRepository.confirmPayByCash(orderDetail.orderId);
      successMessage = 'Payment confirmed!';
      failureMessage = 'Cannot confirm payment!';
      Navigator.pop(context, 1);
      isButtonPressed = true;
    } else {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(response != '500' ? successMessage : failureMessage)),
    );
  }

  void _showRefundDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Refund Items"),
            content: _RefundItemsList(orderDetail: orderDetail),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (orderStatus == "Prepare")
          _buildActionButton(
            context,
            'Confirm Order',
            isButtonPressed ? Colors.grey : Colors.green,
            isButtonPressed,
            false,
            () => _handleOrderAction(context, 'confirm'),
          ),
        if (orderStatus == "Prepare" && getAdditionalItems(orderDetail).isEmpty)
          _buildActionButton(
            context,
            'Cancel Order',
            isButtonPressed ? Colors.grey : Colors.red,
            isButtonPressed,
            true,
            () => _handleOrderAction(context, 'cancel'),
          ),
        if (orderStatus == "Prepare" &&
            getAdditionalItems(orderDetail).isNotEmpty)
          _buildActionButton(
            context,
            'Cancel Additional Items',
            isButtonPressed ? Colors.grey : Colors.red,
            isButtonPressed,
            true,
            () => _handleOrderAction(context, 'cancelAddMore'),
          ),
        if (orderStatus == "Service")
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showRefundDialog(context),
              child: Text('Return item',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        if (orderStatus == "Payment")
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _BuildPaymentWidget(orderId: orderDetail.orderId),
              _buildActionButton(
                context,
                'Confirm receiving payment',
                isButtonPressed ? Colors.grey : Colors.blue,
                isButtonPressed,
                false,
                () => _handleOrderAction(context, 'confirmPayment'),
              )
            ],
          ),
        if (orderStatus == "Finish")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BuildPaymentWidget(orderId: orderDetail.orderId),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String text, Color color,
      bool isButtonPressed, bool isButtonCancel, VoidCallback onPressed) {
    if (isButtonCancel == false) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isButtonPressed ? null : onPressed,
          child:
              Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isButtonPressed ? null : onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.red),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(text,
              style: const TextStyle(fontSize: 18, color: Colors.red)),
        ),
      );
    }
  }
}

class _BuildPaymentWidget extends StatelessWidget {
  final String orderId;
  final paymentRepository = GetIt.I<IPaymentRepository>();

  _BuildPaymentWidget({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PaymentItem>>(
      future: paymentRepository.getPayment(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final payments = snapshot.data!;
          if (payments.isEmpty) {
            return const Text('No payments found');
          }
          final payment = payments[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Discount Member Point: ${payment.reduceAmount}',
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Final Price: ${formatCurrency(payment.finalAmount)} VND',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

String formatCurrency(int value) {
  var formatter = NumberFormat.decimalPattern('vi_VN');
  return formatter.format(value);
}

List<OrderDetailItem> getItems(OrderDetail orderDetail) {
  return orderDetail.orderDetails
      .where((item) => item.isAddMore == false && item.status != "Canceled")
      .toList();
}

List<OrderDetailItem> getAdditionalItems(OrderDetail orderDetail) {
  return orderDetail.orderDetails
      .where((item) => item.isAddMore == true && item.status != "Canceled")
      .toList();
}

class _RefundItemsList extends StatefulWidget {
  final OrderDetail orderDetail;

  const _RefundItemsList({Key? key, required this.orderDetail})
      : super(key: key);

  @override
  _RefundItemsListState createState() => _RefundItemsListState();
}

class _RefundItemsListState extends State<_RefundItemsList> {
  List<OrderDetailItem> refundableItems = [];
  Map<String, int> adjustedRefundQuantities = {};
  final orderRepository = GetIt.I<IOrderRepository>();

  @override
  void initState() {
    super.initState();
    refundableItems = widget.orderDetail.orderDetails.where((item) {
      return item.isRefund == true &&
          0 <= item.quantity &&
          item.status != "Canceled";
    }).toList();
    refundableItems.forEach((item) {
      adjustedRefundQuantities[item.id] = (item.quantity - item.refundQuantity);
    });
  }

  void _updateRefundQuantity(String itemId, int newQuantity) {
    setState(() {
      if (newQuantity >= 0 &&
          newQuantity <=
              refundableItems
                  .firstWhere((item) => item.id == itemId)
                  .quantity) {
        adjustedRefundQuantities[itemId] = newQuantity;
      }
    });
  }

  void _confirmRefund() async {
    List<OrderDetailItem> itemsToRefund = refundableItems.where((item) {
      int adjustedQuantity = adjustedRefundQuantities[item.id] ?? 0;
      return adjustedQuantity > 0;
    }).toList();

    if (itemsToRefund.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Processing refunds...")),
      );
      for (var item in itemsToRefund) {
        final int refundQuantity = adjustedRefundQuantities[item.id] ?? 0;

        try {
          final response = await orderRepository.refundOrder(
            orderId: widget.orderDetail.orderId,
            orderDetailId: item.id,
            refundQuantity: refundQuantity,
          );
          if (response == '200') {
            print("Successfully refunded item: ${item.productName}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("Successfully refunded item: ${item.productName}")),
            );
            Navigator.pop(context, 1);
          } else {
            print(
                "Failed to refund item: ${item.productName}, Response: $response");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Failed to refund item: ${item.productName}")),
            );
          }
        } catch (e) {
          print(
              "An error occurred while refunding item: ${item.productName}, Error: $e");
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Refund process completed.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No items selected for refund")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...refundableItems.map((item) {
          int adjustedQuantity = adjustedRefundQuantities[item.id] ??
              (item.quantity - item.refundQuantity);

          return ListTile(
            title: Text(item.productName ?? 'Unknown Product'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: adjustedQuantity > 0
                      ? () =>
                          _updateRefundQuantity(item.id, adjustedQuantity - 1)
                      : null,
                ),
                Text(adjustedQuantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: adjustedQuantity <
                          (item.quantity - item.refundQuantity)
                      ? () =>
                          _updateRefundQuantity(item.id, adjustedQuantity + 1)
                      : null,
                ),
              ],
            ),
          );
        }).toList(),
        ElevatedButton(
          onPressed: _confirmRefund,
          child: Text('Confirm Refund'),
        ),
      ],
    );
  }
}
