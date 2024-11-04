import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';

class OrderDetailPage extends StatefulWidget {
  final String id;
  final int tableNumber;
  final String orderStatus;

  const OrderDetailPage({
    Key? key,
    required this.id,
    required this.tableNumber,
    required this.orderStatus,
  }) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetailPage> {
  final OrderRepository orderRepository = OrderRepository();
  late Future<OrderDetail> orderDetailFuture;

  @override
  void initState() {
    super.initState();
    orderDetailFuture = orderRepository.getOrderDetailById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details for Table ${widget.tableNumber}'),
      ),
      body: FutureBuilder<OrderDetail>(
        future: orderDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No order details found.'));
          } else {
            final orderDetail = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: orderDetail.orderDetails.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final item = orderDetail.orderDetails[index];
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
                        ),
                        trailing: Text(
                          '${(item.price * item.quantity).toStringAsFixed(2)} VND',
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Price: ${orderDetail.totalPrice} VND',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (widget.orderStatus == "Prepare")
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final response = await orderRepository
                              .confirmOrder(orderDetail.orderId);
                          if (response != '500') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Order confirmed!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cannot confirm order!')),
                            );
                          }
                        },
                        child: Text(
                          'Confirm Order',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
