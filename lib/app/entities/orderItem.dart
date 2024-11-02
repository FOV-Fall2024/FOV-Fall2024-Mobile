class OrderItem {
  final String id;
  final String orderStatus;
  final int totalPrice;
  final String orderTime;
  final String tableId;
  final int tableNumber;

  OrderItem({
    required this.id,
    required this.orderStatus,
    required this.totalPrice,
    required this.orderTime,
    required this.tableId,
    required this.tableNumber,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderStatus: json['orderStatus'],
      totalPrice: json['totalPrice'],
      orderTime: json['orderTime'],
      tableId: json['tableId'],
      tableNumber: json['tableNumber'],
    );
  }
}
