class OrderDetail {
  final String orderId;
  final String orderStatus;
  final int totalPrice;
  final String orderTime;
  final List<OrderDetailItem> orderDetails;

  OrderDetail({
    required this.orderId,
    required this.orderStatus,
    required this.totalPrice,
    required this.orderTime,
    required this.orderDetails,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    var orderDetailsJson = json['orderDetails'] as List;
    List<OrderDetailItem> orderDetailsList =
        orderDetailsJson.map((item) => OrderDetailItem.fromJson(item)).toList();
    return OrderDetail(
      orderId: json['orderId'],
      orderStatus: json['orderStatus'],
      totalPrice: json['totalPrice'],
      orderTime: json['orderTime'],
      orderDetails: orderDetailsList,
    );
  }
}

class OrderDetailItem {
  final String id;
  final String? comboId;
  final String? productId;
  final String? comboName;
  final String? productName;
  final String? thumbnail;
  final String? image;
  final String status;
  final int quantity;
  final bool isRefund;
  final int refundQuantity;
  final int price;
  final String note;
  final bool isAddMore;

  OrderDetailItem({
    required this.id,
    this.comboId,
    this.productId,
    this.comboName,
    this.productName,
    this.thumbnail,
    this.image,
    required this.status,
    required this.quantity,
    required this.isRefund,
    required this.refundQuantity,
    required this.price,
    required this.note,
    required this.isAddMore,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) {
    return OrderDetailItem(
      id: json['id'],
      comboId: json['comboId'],
      productId: json['productId'],
      comboName: json['comboName'],
      productName: json['productName'],
      thumbnail: json['thumbnail'],
      image: json['image'],
      status: json['status'],
      quantity: json['quantity'],
      isRefund: json['isRefund'],
      refundQuantity: json['refundQuantity'],
      price: json['price'],
      note: json['note'],
      isAddMore: json['isAddMore'],
    );
  }

  get orderTime => null;
}
