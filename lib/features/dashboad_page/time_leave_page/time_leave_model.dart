import 'package:intl/intl.dart';

class TimeLeaveModel {
  final String employeeId;
  final String? employee;
  final String? employeeKh;
  final String? leaveType;
  final String startDate;
  final String endDate;
  final String timeshift;
  final String? leaveName;
  final String reason;
  final String? status;

  TimeLeaveModel({
    required this.employeeId,
    this.employee,
    this.employeeKh,
    this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.timeshift,
    this.leaveName,
    required this.reason,
    this.status,
  });

  factory TimeLeaveModel.fromJson(Map<String, dynamic> json) {
    return TimeLeaveModel(
      employeeId: json['employee_id'] as String,
      employee: json['employee'] as String,
      employeeKh: json['employee_kh'] as String,
      leaveType: json['leave_type'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      timeshift: json['timeshift'] as String,
      leaveName: json['leave_name'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee': employee,
      'employee_kh': employeeKh,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'timeshift': timeshift,
      'leave_name': leaveName,
      'reason': reason,
      'status': status,
    };
  }
}

class AddLeaveModel {
  String? date;
  int? biller;
  int? employeeId;
  DateTime startDate;
  DateTime endDate;
  String? timeshift;
  String? reason;
  int? leaveType;
  String? note;
  int? createdBy;

  AddLeaveModel({
    this.date,
    this.biller,
    this.employeeId,
    required this.startDate,
    required this.endDate,
    this.timeshift,
    this.reason,
    this.leaveType,
    this.note,
    this.createdBy,
  });

  factory AddLeaveModel.fromJson(Map<String, dynamic> json) => AddLeaveModel(
    date: json["date"],
    biller: json["biller"],
    employeeId: json["employee_id"],
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
    timeshift: json["timeshift"],
    reason: json["reason"],
    leaveType: json["leave_type"],
    note: json["note"],
    createdBy: json["created_by"],
  );

  Map<String, String> toJson() => {
    "date": date ?? '',
    "biller": biller?.toString() ?? '',
    "employee_id": employeeId?.toString() ?? '',
    'start_date': DateFormat('yyy-MM-dd').format(startDate),
    'end_date': DateFormat('yyy-MM-dd').format(endDate),
    "timeshift": timeshift ?? '',
    "reason": reason ?? '',
    "leave_type": leaveType?.toString() ?? '',
    "note": note ?? '',
    "created_by": createdBy?.toString() ?? '',
  };
}
class LeaveType {
  final String? id;
  final String? code;
  final String? name; 
  final String? description;
  final String? categoryId;
  final String? days;
  final String? includeHoliday;

  LeaveType({
    this.id,
    this.code,
    this.name, 
    this.description,
    this.categoryId, 
    this.days,
    this.includeHoliday,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id']?.toString(), 
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString() == "" ? null : json['description']?.toString(),
      categoryId: json['category_id']?.toString(),
      days: json['days']?.toString(),
      includeHoliday: json['include_holiday']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "description": description,
    "category_id": categoryId,
    "days": days,
    "include_holiday": includeHoliday,
  };
}