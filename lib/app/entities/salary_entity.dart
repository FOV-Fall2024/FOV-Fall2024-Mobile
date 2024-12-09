class Employee {
  final String id;
  final String employeeCode;
  final String employeeName;
  final Salary salary;
  final DateTime createdDate;

  Employee({
    required this.id,
    required this.employeeCode,
    required this.employeeName,
    required this.salary,
    required this.createdDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeCode: json['employeeCode'],
      employeeName: json['employeeName'],
      salary: Salary.fromJson(json['salary']),
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}

class Salary {
  final int totalShifts;
  final int totalHoursWorked;
  final int actualHoursWorked;
  final double regularSalary;
  final double overtimeSalary;
  final double penalty;
  final double totalSalaries;
  final int overtimeHours;
  final int penaltyHours;
  final List<AttendanceDetails> attendanceDetailsDtos;

  Salary({
    required this.totalShifts,
    required this.totalHoursWorked,
    required this.actualHoursWorked,
    required this.regularSalary,
    required this.overtimeSalary,
    required this.penalty,
    required this.totalSalaries,
    required this.overtimeHours,
    required this.penaltyHours,
    required this.attendanceDetailsDtos,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    var attendanceList = (json['attendanceDetailsDtos'] as List)
        .map((item) => AttendanceDetails.fromJson(item))
        .toList();

    return Salary(
      totalShifts: json['totalShifts'],
      totalHoursWorked: json['totalHoursWorked'],
      actualHoursWorked: json['actualHoursWorked'],
      regularSalary: double.parse(json['regularSalary'].toString()),
      overtimeSalary: double.parse(json['overtimeSalary'].toString()),
      penalty: double.parse(json['penalty'].toString()),
      totalSalaries: double.parse(json['totalSalaries'].toString()),
      overtimeHours: json['overtimeHours'],
      penaltyHours: json['penaltyHours'],
      attendanceDetailsDtos: attendanceList,
    );
  }
}

class AttendanceDetails {
  final String date;
  final String shiftName;
  final String checkInTime;
  final String checkOutTime;

  AttendanceDetails({
    required this.date,
    required this.shiftName,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) {
    return AttendanceDetails(
      date: json['date'],
      shiftName: json['shiftName'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
    );
  }

  @override
  String toString() {
    return 'Shift: $shiftName, Check-In: $checkInTime, Check-Out: $checkOutTime';
  }
}

class EmployeeResponse {
  final int pageNumber;
  final int pageSize;
  final int totalNumberOfPages;
  final int totalNumberOfRecords;
  final List<Employee> results;

  EmployeeResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalNumberOfPages,
    required this.totalNumberOfRecords,
    required this.results,
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    var employeeList = (json['results'] as List)
        .map((item) => Employee.fromJson(item))
        .toList();

    return EmployeeResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalNumberOfPages: json['totalNumberOfPages'],
      totalNumberOfRecords: json['totalNumberOfRecords'],
      results: employeeList,
    );
  }
}
