class Shifts {
  String id;
  String shiftName;
  String startTime;
  String endTime;
  DateTime createdDate;

  Shifts({
    required this.id,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.createdDate,
  });

  factory Shifts.fromJson(Map<String, dynamic> json) => Shifts(
        id: json["id"],
        shiftName: json["shiftName"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shiftName": shiftName,
        "startTime": startTime,
        "endTime": endTime,
        "createdDate": createdDate.toIso8601String(),
      };
}
