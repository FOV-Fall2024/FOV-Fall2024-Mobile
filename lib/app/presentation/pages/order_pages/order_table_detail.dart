import 'package:flutter/material.dart';

class OrderTableDetail extends StatelessWidget {
  final String tableId;

  const OrderTableDetail({Key? key, required this.tableId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for order items
    final List<OrderDetail> orderItems = [
      OrderDetail(
        itemName: 'Bún chả giò chay',
        imageUrl: 'https://dukaan.b-cdn.net/700x700/webp/upload_file_service/6a0df908-a609-43ba-a1bd-8cf07c019ff0/bun-cha-gio-chay-jpg',
        quantity: 2,
        price: 2.5,
      ),
      OrderDetail(
        itemName: 'Cơm tấm chay',
        imageUrl: 'https://product.hstatic.net/200000567755/product/com_tam_na_bi_cham___nam_bi_cha__0d7619a4cb094613933bdb2ff214973f_1024x1024.png',
        quantity: 1,
        price: 2.5,
      ),
    ];

    // Calculate total price
    double totalPrice = orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details for $tableId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ordering details
            Expanded(
              child: ListView.separated(
                itemCount: orderItems.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  return ListTile(
                    leading: Image.network(item.imageUrl, width: 50, height: 50),
                    title: Text(item.itemName),
                    subtitle: Text('Qty: ${item.quantity} - \$${item.price.toStringAsFixed(2)}'),
                    trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            // Divider(),
            // SizedBox(height: 8),
            // Total price
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// OrderDetail model, will move later
class OrderDetail {
  final String itemName;
  final String imageUrl;
  final int quantity;
  final double price;

  OrderDetail({
    required this.itemName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}
