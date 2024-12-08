import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final int tableNo;
  final String orderStatus;
  final DateTime orderTime;

  ItemCard({
    required this.tableNo,
    required this.orderStatus,
    required this.orderTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(orderTime),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table number', style: TextStyle(fontSize: 14)),
                    Text(
                      tableNo.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status', style: TextStyle(fontSize: 14)),
                    Text(
                      orderStatus,
                      style: TextStyle(
                          color: getStatusColor(orderStatus),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('View detail >',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Prepare':
      return Colors.deepOrangeAccent;
    case 'Cook':
      return Colors.amber;
    case 'Cooked':
      return Colors.yellow;
    case 'Service':
      return Colors.redAccent;
    case 'Payment':
      return Colors.blue;
    case 'Finish':
      return Colors.green;
    case 'Canceled':
      return Colors.grey;
    default:
      return Colors.black;
  }
}
