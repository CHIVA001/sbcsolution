import 'dart:convert';

// class AttendanceModel {
//   final bool status;
//   final String message;
//   final AttendanceData? data;

//   AttendanceModel({required this.status, required this.message, this.data});

//   factory AttendanceModel.fromJson(Map<String, dynamic> json) {
//     return AttendanceModel(
//       status: json['status'] ?? false,
//       message: json['message'] ?? "",
//       data: json['data'] != null ? AttendanceData.fromJson(json['data']) : null,
//     );
//   }
// }

class AttendanceData {
  final String? id;
  final String employeeId;
  final String userId;
  final String? shiftDate;
  final DateTime? shiftStarttime;
  final DateTime? shiftEndtime;
  final String shiftStatus;
  final String? shiftIntype;
  final String? shiftOuttype;
  final String? companyStatus;
  final String? shiftTotalTime;
  final String? checkinLocation;
  final String? checkoutLocation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AttendanceData({
    this.id,
    required this.employeeId,
    required this.userId,
    this.shiftDate,
    this.shiftStarttime,
    this.shiftEndtime,
    required this.shiftStatus,
    this.shiftIntype,
    this.shiftOuttype,
    this.companyStatus,
    this.shiftTotalTime,
    this.checkinLocation,
    this.checkoutLocation,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      id: json['id'] ?? "",
      employeeId: json['employee_id'] ?? "",
      userId: json['user_id'] ?? "",
      shiftDate: json['shift_date'] ?? "",
      shiftStarttime: json['shift_starttime'] ?? "",
      shiftEndtime: json['shift_endtime'] ?? "",
      shiftStatus: json['shift_status'] ?? "",
      shiftIntype: json['shift_intype'] ?? "",
      shiftOuttype: json['shift_outtype'],
      companyStatus: json['company_status'] ?? "",
      shiftTotalTime: json['shift_total_time'],
      checkinLocation: json['checkin_location'] ?? "",
      checkoutLocation: json['checkout_location'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}

// =======================================================
class CurrentShift {
  final int shiftId;
  final String startTime;
  final String normalStartTime;

  CurrentShift({
    required this.shiftId,
    required this.startTime,
    required this.normalStartTime,
  });

  factory CurrentShift.fromJson(Map<String, dynamic> json) {
    return CurrentShift(
      shiftId: json['shift_id'],
      startTime: json['start_time'],
      normalStartTime: json['normal_starttime'],
    );
  }
}

// =====================================================
// class GetAttendanceModel {
//   final String id;
//   final String empcode;
//   final String fullName;
//   final String checkTime;

//   const GetAttendanceModel({
//     required this.id,
//     required this.empcode,
//     required this.fullName,
//     required this.checkTime,
//   });

//   factory GetAttendanceModel.fromJson(Map<String, dynamic> json) =>
//       GetAttendanceModel(
//         id: json['id'] ?? '',
//         empcode: json['empcode'] ?? '',
//         fullName: json['full_name'] ?? '',
//         checkTime: json['check_time'] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'empcode': empcode,
//     'full_name': fullName,
//     'check_time': checkTime,
//   };

//   /// Optional: Convert check_time to DateTime
//   DateTime? get checkTimeAsDate {
//     try {
//       return DateTime.parse(checkTime);
//     } catch (_) {
//       return null;
//     }
//   }
// }

//
class CheckInOutModel {
  final String id;
  final String employeeId;
  final String empcode;
  final String fullName;
  final String checkIn;
  final String checkOut;
  final String? shiftTotalTime;
  final LocationModel? checkinLocation;
  final LocationModel? checkoutLocation;

  CheckInOutModel({
    required this.id,
    required this.employeeId,
    required this.empcode,
    required this.fullName,
    required this.checkIn,
    required this.checkOut,
    this.shiftTotalTime,
    this.checkinLocation,
    this.checkoutLocation,
  });

  factory CheckInOutModel.fromJson(Map<String, dynamic> json) {
    return CheckInOutModel(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      empcode: json['empcode'] ?? '',
      fullName: json['full_name'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      shiftTotalTime: json['shift_total_time']?.toString(),
      checkinLocation: json['checkin_location'] != null
          ? LocationModel.fromJson(
              Map<String, dynamic>.from(
                jsonDecode(json['checkin_location']),
              ),
            )
          : null,
      checkoutLocation: json['checkout_location'] != null
          ? LocationModel.fromJson(
              Map<String, dynamic>.from(
                jsonDecode(json['checkout_location']),
              ),
            )
          : null,
    );
  }
}

class LocationModel {
  final String latitude;
  final String longitude;

  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitute'] ?? '',
      longitude: json['longitute'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitute': latitude,
      'longitute': longitude,
    };
  }
}


class CheckInOutRequest {
  final String type;
  final String empId;
  final String userId;
  final String? shiftId;

  CheckInOutRequest({
    required this.type,
    required this.empId,
    required this.userId,
    this.shiftId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'emp_id': empId,
      'user_id': userId,
    };
    if (shiftId != null) {
      data['shift_id'] = shiftId;
    }
    return data;
  }
}
