import 'dart:convert';

class PaymentItem {
  final String paymentId;
  final String orderId;
  final int amount;
  final int reduceAmount;
  final int finalAmount;
  final String paymentStatus;
  final String paymentMethods;
  final DateTime createdDate;

  PaymentItem({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.reduceAmount,
    required this.finalAmount,
    required this.paymentStatus,
    required this.paymentMethods,
    required this.createdDate,
  });

  // Factory method to create an instance from JSON
  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    return PaymentItem(
      paymentId: json['paymentId'],
      orderId: json['orderId'],
      amount: json['amount'],
      reduceAmount: json['reduceAmount'],
      finalAmount: json['finalAmount'],
      paymentStatus: json['paymentStatus'],
      paymentMethods: json['paymentMethods'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'amount': amount,
      'reduceAmount': reduceAmount,
      'finalAmount': finalAmount,
      'paymentStatus': paymentStatus,
      'paymentMethods': paymentMethods,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PaymentItem(paymentId: $paymentId, orderId: $orderId, amount: $amount, '
        'reduceAmount: $reduceAmount, finalAmount: $finalAmount, paymentStatus: $paymentStatus, '
        'paymentMethods: $paymentMethods, createdDate: $createdDate)';
  }
}

// Helper function to parse a list of PaymentItem from JSON
List<PaymentItem> paymentItemListFromJson(String jsonString) {
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => PaymentItem.fromJson(json)).toList();
}

// Helper function to convert a list of PaymentItem to JSON
String paymentItemListToJson(List<PaymentItem> items) {
  final List<Map<String, dynamic>> jsonList =
      items.map((item) => item.toJson()).toList();
  return json.encode(jsonList);
}
