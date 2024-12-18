import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/orderItem.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/order_page.component.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/order_pages/order_detail_page.dart';
import 'package:get_it/get_it.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final orderRepository = GetIt.I<IOrderRepository>();
  late Future<List<OrderItem>> orders;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    orders = fetchFilteredOrders();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          orders = fetchFilteredOrders();
        });
      }
    });
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<OrderItem>> fetchFilteredOrders() async {
    final allOrders = await orderRepository.getOrders();
    if (selectedStatus == 'all') {
      return allOrders;
    }
    return allOrders
        .where((order) => order.orderStatus == selectedStatus)
        .toList();
  }

  void _onStatusChanged(String? status) {
    setState(() {
      selectedStatus = status;
      orders = fetchFilteredOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter', style: TextStyle(fontSize: 20)),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'Prepare', child: Text('Prepare')),
                    DropdownMenuItem(value: 'Cook', child: Text('Cook')),
                    DropdownMenuItem(value: 'Cooked', child: Text('Cooked')),
                    DropdownMenuItem(value: 'Service', child: Text('Service')),
                    DropdownMenuItem(value: 'Payment', child: Text('Payment')),
                    DropdownMenuItem(value: 'Finish', child: Text('Finish')),
                    DropdownMenuItem(
                        value: 'Canceled', child: Text('Canceled')),
                  ],
                  onChanged: _onStatusChanged,
                  hint: const Text('Select Status'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Orders list
            Expanded(
              child: FutureBuilder<List<OrderItem>>(
                future: orders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No orders found'));
                  }

                  final orderList = snapshot.data!;
                  return ListView.separated(
                    itemCount: orderList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final order = orderList[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailPage(
                                id: order.id,
                                tableNumber: order.tableNumber,
                                orderStatus: order.orderStatus,
                              ),
                            ),
                          );
                          if (result == 1) {
                            setState(() {
                              orders = fetchFilteredOrders();
                            });
                          }
                        },
                        child: ItemCard(
                          orderStatus: order.orderStatus,
                          orderTime: DateTime.parse(order.orderTime)
                              .add(Duration(hours: 7)),
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
