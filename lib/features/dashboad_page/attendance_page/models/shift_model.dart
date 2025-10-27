class ShiftModel {
  final String? id;
  final String employeeId;
  final String userId;
  final DateTime? shiftDate;
  final DateTime? shiftStartTime;
  final DateTime? shiftEndTime;
  final int? shiftStatus;
  final int? shiftId;
  final int? shiftInType;
  final int? shiftOutType;
  final int? companyStatus;
  final int? shiftTotalTime;
  final String? shiftTotalFormat;
  final String? checkinLocation;
  final String? checkoutLocation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShiftModel({
    this.id,
    required this.employeeId,
    required this.userId,
    this.shiftId,
    this.shiftDate,
    this.shiftStartTime,
    this.shiftEndTime,
    this.shiftStatus,
    this.shiftInType,
    this.shiftOutType,
    this.companyStatus,
    this.shiftTotalTime,
    this.shiftTotalFormat,
    this.checkinLocation,
    this.checkoutLocation,
    this.createdAt,
    this.updatedAt,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id']?.toString(),
      employeeId: json['employee_id']?.toString() ?? "",
      userId: json['user_id']?.toString() ?? "",
      shiftDate: _parseDate(json['shift_date']),
      shiftStartTime: _parseDate(json['shift_starttime']),
      shiftEndTime: _parseDate(json['shift_endtime']),
      shiftStatus: int.tryParse(json['shift_status']?.toString() ?? "0"),
      shiftId: int.tryParse(json['shift_id']?.toString() ?? "0"),
      shiftInType: int.tryParse(json['shift_intype']?.toString() ?? "0"),
      shiftOutType: int.tryParse(json['shift_outtype']?.toString() ?? "0"),
      companyStatus: int.tryParse(json['company_status']?.toString() ?? "0"),
      shiftTotalTime: int.tryParse(json['shift_total_time']?.toString() ?? "0"),
      shiftTotalFormat: json['shift_total_format']?.toString(),
      checkinLocation: json['checkin_location']?.toString(),
      checkoutLocation: json['checkout_location']?.toString(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "employee_id": employeeId,
      "user_id": userId,
      "shift_date": shiftDate?.toIso8601String(),
      "shift_starttime": shiftStartTime?.toIso8601String(),
      "shift_endtime": shiftEndTime?.toIso8601String(),
      "shift_status": shiftStatus,
      "shift_intype": shiftInType,
      "shift_outtype": shiftOutType,
      "shift_id": shiftId,
      "company_status": companyStatus,
      "shift_total_time": shiftTotalTime,
      "shift_total_format": shiftTotalFormat,
      "checkin_location": checkinLocation,
      "checkout_location": checkoutLocation,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null ||
        value.toString().isEmpty ||
        value.toString().startsWith("0000")) {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }
}
