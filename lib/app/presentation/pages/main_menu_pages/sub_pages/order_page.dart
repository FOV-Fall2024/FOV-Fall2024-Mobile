import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/orderItem.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/order_page.component.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/order_pages/order_detail_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/background_image_by_time.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderRepository orderRepository = OrderRepository();
  late Future<List<OrderItem>> orders;
  String? selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    orders = fetchFilteredOrders();
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundImage()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter', style: TextStyle(fontSize: 20)),
                        DropdownButton<String>(
                          value: selectedStatus,
                          items: [
                            DropdownMenuItem(value: 'all', child: Text('All')),
                            DropdownMenuItem(
                                value: 'Prepare', child: Text('Prepare')),
                            DropdownMenuItem(
                                value: 'Cook', child: Text('Cook')),
                            DropdownMenuItem(
                                value: 'Service', child: Text('Service')),
                            DropdownMenuItem(
                                value: 'Payment', child: Text('Payment')),
                            DropdownMenuItem(
                                value: 'Finish', child: Text('Finish')),
                            DropdownMenuItem(
                                value: 'Canceled', child: Text('Canceled')),
                          ],
                          onChanged: _onStatusChanged,
                          hint: Text('Select Status'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
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
        ],
      ),
    );
  }
}
