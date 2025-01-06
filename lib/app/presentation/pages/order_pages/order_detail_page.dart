import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/OrderDetail.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';
import './order_detal_page.component.dart';

class OrderDetailPage extends StatefulWidget {
  final String id;
  final int tableNumber;
  final String orderStatus;
  final String? paymentMethods;

  const OrderDetailPage({
    Key? key,
    required this.id,
    required this.tableNumber,
    required this.orderStatus,
    required this.paymentMethods,
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
    _refreshOrderDetails();
  }

  void _refreshOrderDetails() {
    if (widget.orderStatus != 'Canceled') {
      setState(() {
        orderDetailFuture =
            orderRepository.getOrderDetailById(widget.id).then((orderDetail) {
          final allItemsService = orderDetail.orderDetails
              .where((item) => item.status != "Canceled")
              .every((item) => item.status == "Service");

          if (
              //filter status for each item inside order detail
              allItemsService &&
                  //filter status for order
                  (widget.orderStatus != "Service" &&
                      widget.orderStatus != "Payment")) {
            Navigator.pop(context, 1);
          }

          return orderDetail;
        });
      });
    } else
      setState(() {
        orderDetailFuture = orderRepository.getOrderDetailById(widget.id);
      });
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
            final items = getItems(orderDetail);
            final additionalItems = getAdditionalItems(orderDetail);

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      ...items.map((item) => OrderItemTile(
                          orderId: widget.id,
                          orderStatus: widget.orderStatus,
                          item: item,
                          onDishServed: _refreshOrderDetails)),
                      if (additionalItems.isNotEmpty)
                        ExpansionTile(
                          title: Text(
                            'Additional Items',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: additionalItems
                              .map((item) => OrderItemTile(
                                    orderId: widget.id,
                                    orderStatus: widget.orderStatus,
                                    item: item,
                                    onDishServed: _refreshOrderDetails,
                                  ))
                              .toList(),
                        ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Total Price: ${formatCurrency(orderDetail.totalPrice)} VND',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                OrderActions(
                    orderDetail: orderDetail,
                    orderRepository: orderRepository,
                    orderStatus: widget.orderStatus,
                    paymentMethods: widget.paymentMethods,
                    onRefresh: _refreshOrderDetails),
                SizedBox(
                  height: 80,
                )
              ],
            );
          }
        },
      ),
    );
  }
}
