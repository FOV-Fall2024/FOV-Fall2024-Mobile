import './view_model/shift_view_model.dart';

class ScheduleResponse {
  final int pageNumber;
  final int pageSize;
  final int totalNumberOfPages;
  final int totalNumberOfRecords;
  final List<ScheduleItem> results;

  ScheduleResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalNumberOfPages,
    required this.totalNumberOfRecords,
    required this.results,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<ScheduleItem> scheduleList =
        list.map((i) => ScheduleItem.fromJson(i)).toList();

    return ScheduleResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalNumberOfPages: json['totalNumberOfPages'],
      totalNumberOfRecords: json['totalNumberOfRecords'],
      results: scheduleList,
    );
  }
}

class ScheduleItem {
  final String id;
  final Shift shift;
  final String date;
  final String createdDate;

  ScheduleItem({
    required this.id,
    required this.shift,
    required this.date,
    required this.createdDate,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'],
      shift: Shift.fromJson(json['shift']),
      date: json['date'],
      createdDate: json['createdDate'],
    );
  }
}
