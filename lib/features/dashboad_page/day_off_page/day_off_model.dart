class DayOffResponse {
  final bool status;
  final String? message;
  final List<DayOffData> data;

  DayOffResponse({required this.status, this.message, required this.data});

  factory DayOffResponse.fromJson(Map<String, dynamic> json) {
    final dynamic data = json['data'];

    if (data is List) {
      final List<DayOffData> dayOffDataList = (data)
          .map((e) => DayOffData.fromJson(e))
          .toList();
      return DayOffResponse(
        status: json['status'] ?? false,
        message: json['message'],
        data: dayOffDataList,
      );
    } else if (data is bool) {
      return DayOffResponse(
        status: json['status'] ?? false,
        message: json['message'],
        data: [],
      );
    }

    return DayOffResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class DayOffData {
  final String? id;
  final String? employeeId;
  final String? dayOff;
  final String? dayOffId;
  final String? description;
  final String? fingerId;
  final String? nricNo;
  final String? empcode;
  final String? candidate;
  final String? candidateStatus;
  final String? firstname;
  final String? lastname;
  final String? firstnameKh;
  final String? lastnameKh;
  final String? photo;
  final String? dob;
  final String? retirement;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? nationality;
  final String? maritalStatus;
  final String? nonResident;
  final String? nssf;
  final String? nssfNumber;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final String? note;
  final String? bookType;
  final String? workPermitNumber;
  final String? workbookNumber;
  final String? type;
  final String? pob;
  final String? moduleType;
  final String? operator;
  final String? commissionRate;
  final String? biller;

  DayOffData({
    this.id,
    this.employeeId,
    this.dayOff,
    this.dayOffId,
    this.description,
    this.fingerId,
    this.nricNo,
    this.empcode,
    this.candidate,
    this.candidateStatus,
    this.firstname,
    this.lastname,
    this.firstnameKh,
    this.lastnameKh,
    this.photo,
    this.dob,
    this.retirement,
    this.gender,
    this.phone,
    this.email,
    this.address,
    this.nationality,
    this.maritalStatus,
    this.nonResident,
    this.nssf,
    this.nssfNumber,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.note,
    this.bookType,
    this.workPermitNumber,
    this.workbookNumber,
    this.type,
    this.pob,
    this.moduleType,
    this.operator,
    this.commissionRate,
    this.biller,
  });

  factory DayOffData.fromJson(Map<String, dynamic> json) {
    return DayOffData(
      id: json['id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      dayOff: json['day_off'],
      dayOffId: json['day_off_id']?.toString(),
      description: json['description'],
      fingerId: json['finger_id'],
      nricNo: json['nric_no'],
      empcode: json['empcode'],
      candidate: json['candidate'],
      candidateStatus: json['candidate_status'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      firstnameKh: json['firstname_kh'],
      lastnameKh: json['lastname_kh'],
      photo: json['photo'],
      dob: json['dob'],
      retirement: json['retirement'],
      gender: json['gender'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      nationality: json['nationality'],
      maritalStatus: json['marital_status'],
      nonResident: json['non_resident'],
      nssf: json['nssf'],
      nssfNumber: json['nssf_number'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'],
      note: json['note'],
      bookType: json['book_type'],
      workPermitNumber: json['work_permit_number'],
      workbookNumber: json['workbook_number'],
      type: json['type'],
      pob: json['pob'],
      moduleType: json['module_type'],
      operator: json['operator'],
      commissionRate: json['commission_rate']?.toString(),
      biller: json['biller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'day_off': dayOff,
      'day_off_id': dayOffId,
      'description': description,
      'finger_id': fingerId,
      'nric_no': nricNo,
      'empcode': empcode,
      'candidate': candidate,
      'candidate_status': candidateStatus,
      'firstname': firstname,
      'lastname': lastname,
      'firstname_kh': firstnameKh,
      'lastname_kh': lastnameKh,
      'photo': photo,
      'dob': dob,
      'retirement': retirement,
      'gender': gender,
      'phone': phone,
      'email': email,
      'address': address,
      'nationality': nationality,
      'marital_status': maritalStatus,
      'non_resident': nonResident,
      'nssf': nssf,
      'nssf_number': nssfNumber,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
      'note': note,
      'book_type': bookType,
      'work_permit_number': workPermitNumber,
      'workbook_number': workbookNumber,
      'type': type,
      'pob': pob,
      'module_type': moduleType,
      'operator': operator,
      'commission_rate': commissionRate,
      'biller': biller,
    };
  }

  String get fullName {
    return "$firstname $lastname";
  }
}
