import 'package:flutter/material.dart';

class OrderTableDetail extends StatefulWidget {
  final String tableId;

  const OrderTableDetail({Key? key, required this.tableId}) : super(key: key);

  @override
  _OrderTableDetailState createState() => _OrderTableDetailState();
}

class _OrderTableDetailState extends State<OrderTableDetail> {
  // Sample data for order items
  List<OrderDetail> orderItems = [
    OrderDetail(
      itemName: 'Bún chả giò chay',
      imageUrl:
          'https://dukaan.b-cdn.net/700x700/webp/upload_file_service/6a0df908-a609-43ba-a1bd-8cf07c019ff0/bun-cha-gio-chay-jpg',
      quantity: 2,
      price: 2.5,
    ),
    OrderDetail(
      itemName: 'Cơm tấm chay',
      imageUrl:
          'https://product.hstatic.net/200000567755/product/com_tam_na_bi_cham___nam_bi_cha__0d7619a4cb094613933bdb2ff214973f_1024x1024.png',
      quantity: 1,
      price: 2.5,
    ),
  ];

  void incrementQuantity(int index) {
    setState(() {
      orderItems[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (orderItems[index].quantity > 1) {
        orderItems[index].quantity--;
      }
    });
  }

  double getTotalPrice() {
    return orderItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details for ${widget.tableId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: orderItems.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final item = orderItems[index];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 50, height: 50),
                  title: Text(item.itemName),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => decrementQuantity(index),
                      ),
                      Text('Qty: ${item.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => incrementQuantity(index),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: \$${getTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order confirmed!')),
                  );
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
      ),
    );
  }
}

// OrderDetail model
class OrderDetail {
  final String itemName;
  final String imageUrl;
  int quantity;
  final double price;

  OrderDetail({
    required this.itemName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}
