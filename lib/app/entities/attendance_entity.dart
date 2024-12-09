import './view_model/shift_view_model.dart';

class AttendanceResponse {
  int pageNumber;
  int pageSize;
  int totalNumberOfPages;
  int totalNumberOfRecords;
  List<Attendance> results;

  AttendanceResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalNumberOfPages,
    required this.totalNumberOfRecords,
    required this.results,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalNumberOfPages: json["totalNumberOfPages"],
        totalNumberOfRecords: json["totalNumberOfRecords"],
        results: List<Attendance>.from(
            json["results"].map((x) => Attendance.fromJson(x))),
      );
}

class Attendance {
  String id;
  String? checkInTime;
  String? checkOutTime;
  WaiterSchedule waiterSchedule;
  DateTime createdDate;

  Attendance({
    required this.id,
    required this.checkInTime,
    required this.checkOutTime,
    required this.waiterSchedule,
    required this.createdDate,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        checkInTime: json["checkInTime"],
        checkOutTime: json["checkOutTime"],
        waiterSchedule: WaiterSchedule.fromJson(json["waiterSchedule"]),
        createdDate: DateTime.parse(json["createdDate"]),
      );
}

class WaiterSchedule {
  String id;
  Employees employee;
  Shift shift;
  bool isCheckIn;

  WaiterSchedule({
    required this.id,
    required this.employee,
    required this.shift,
    required this.isCheckIn,
  });

  factory WaiterSchedule.fromJson(Map<String, dynamic> json) => WaiterSchedule(
      id: json["id"],
      employee: Employees.fromJson(json["employee"]),
      shift: Shift.fromJson(json["shift"]),
      isCheckIn: json["isCheckIn"]);
}

class Employees {
  String employeeId;
  String employeeCode;
  String employeeName;
  String waiterScheduleId;

  Employees({
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.waiterScheduleId,
  });

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        employeeId: json["employeeId"],
        employeeCode: json["employeeCode"],
        employeeName: json["employeeName"],
        waiterScheduleId: json["waiterScheduleId"],
      );
}
