class OrderItem {
  final String id;
  final String orderStatus;
  final dynamic totalPrice;
  final dynamic reduceAmount;
  final dynamic finalAmount;
  final String orderTime;
  final String tableId;
  final String? paymentMethods;
  final int tableNumber;
  final String customerName;
  final String? phoneNumber;
  final String? feedback;
  final String createdDate;

  OrderItem({
    required this.id,
    required this.orderStatus,
    required this.totalPrice,
    required this.reduceAmount,
    required this.finalAmount,
    required this.orderTime,
    required this.tableId,
    required this.paymentMethods,
    required this.tableNumber,
    required this.customerName,
    required this.phoneNumber,
    required this.feedback,
    required this.createdDate,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderStatus: json['orderStatus'],
      totalPrice: json['totalPrice'],
      reduceAmount: json['reduceAmount'],
      finalAmount: json['finalAmount'],
      orderTime: json['orderTime'],
      tableId: json['tableId'],
      paymentMethods: json['paymentMethods'],
      tableNumber: json['tableNumber'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      feedback: json['feedback'],
      createdDate: json['createdDate'],
    );
  }
}
