import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/order_pages/order_table_detail.dart'; // Import the detail page

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderItem> orders = [
    OrderItem(tableId: 'Table 1', status: 'ordering'),
    OrderItem(tableId: 'Table 2', status: 'waiting for food'),
    OrderItem(tableId: 'Table 3', status: 'awaiting payment'),
    OrderItem(tableId: 'Table 4', status: 'done'),
  ];

  // Sample method to get color based on status
  Color getStatusColor(String status) {
    switch (status) {
      case 'ordering':
        return Colors.red;
      case 'waiting for food':
        return Colors.cyan;
      case 'awaiting payment':
        return Colors.orange;
      case 'done':
        return Colors.green;
      default:
        return Colors.black;
    }
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
                    DropdownMenuItem(value: 'ordering', child: Text('Ordering')),
                    DropdownMenuItem(value: 'waiting for food', child: Text('Waiting for Food')),
                    DropdownMenuItem(value: 'awaiting payment', child: Text('Awaiting Payment')),
                    DropdownMenuItem(value: 'done', child: Text('Done')),
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
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to OrderTableDetail on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTableDetail(
                            tableId: order.tableId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: getStatusColor(order.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Table: ${order.tableId} - Status: ${order.status}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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

// OrderItem model to represent orders
class OrderItem {
  final String tableId;
  final String status;

  OrderItem({required this.tableId, required this.status});
}
