import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/orderItem.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/order_page.component.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/order_pages/order_detail_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderRepository orderRepository = OrderRepository();
  late Future<List<OrderItem>> orders;

  void initState() {
    super.initState();
    orders = orderRepository.getOrders();
  }

  void getOrder() async {
    orders = orderRepository.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter', style: TextStyle(fontSize: 20)),
                DropdownButton<String>(
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'Prepare', child: Text('Prepare')),
                    DropdownMenuItem(value: 'Cook', child: Text('Cook')),
                    DropdownMenuItem(value: 'Service', child: Text('Service')),
                    DropdownMenuItem(value: 'Payment', child: Text('Payment')),
                    DropdownMenuItem(value: 'Finish', child: Text('Finish')),
                    DropdownMenuItem(
                        value: 'Canceled', child: Text('Canceled')),
                  ],
                  onChanged: (value) {
                    // Handle filtering logic here
                  },
                  hint: Text('Select Status'),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Orders list
            Expanded(
              child: FutureBuilder<List<OrderItem>>(
                future: orders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No orders found'));
                  }

                  final orderList = snapshot.data!;
                  return ListView.separated(
                    itemCount: orderList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final order = orderList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailPage(
                                id: order.id,
                                tableNumber: order.tableNumber,
                                orderStatus: order.orderStatus,
                              ),
                            ),
                          );
                        },
                        child: ItemCard(
                          orderStatus: order.orderStatus,
                          orderTime: DateTime.parse(order.orderTime),
                          tableNo: order.tableNumber,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
