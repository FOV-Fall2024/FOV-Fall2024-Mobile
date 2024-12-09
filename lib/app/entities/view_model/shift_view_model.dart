class Shift {
  String shiftId;
  String shiftName;

  Shift({
    required this.shiftId,
    required this.shiftName,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        shiftId: json["shiftId"],
        shiftName: json["shiftName"],
      );
}
