// models/user_model.dart
class UserModel {
  final String id;
  final String empId;
  final String firstName;
  final String lastName;
  final String username;
  final String gender;
  final String company;
  final String phone;
  final String email;
  final String billerId;
  final String active;
  final String? avatar;
  final String? nationality;
  final String position;
  final String? employeedDate;
  final String? userType;
  final String basicSalary;
  final String isRemoteAllow;
  final String candidate;
  final String? photo;
  final String companyName;
  final String departmentName;
  final String positionName;
  final String policyName;
  final String? image;

  UserModel({
    required this.id,
    required this.empId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.gender,
    required this.company,
    required this.phone,
    required this.email,
    required this.billerId,
    required this.active,
    this.avatar,
    this.nationality,
    required this.position,
    this.employeedDate,
    this.userType,
    required this.basicSalary,
    required this.isRemoteAllow,
    required this.candidate,
    this.photo,
    required this.companyName,
    required this.departmentName,
    required this.positionName,
    required this.policyName,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      empId: json["emp_id"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      username: json["username"] ?? "",
      gender: json["gender"] ?? "",
      company: json["company"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      billerId: json["biller_id"] ?? "",
      active: json["active"] ?? "0",
      avatar: json["avatar"],
      nationality: json["nationality"],
      position: json["position"] ?? "0",
      employeedDate: json["employeed_date"],
      userType: json["user_type"],
      basicSalary: json["basic_salary"] ?? "0.000",
      isRemoteAllow: json["is_remote_allow"] ?? "0",
      candidate: json["candidate"] ?? "0",
      photo: json["photo"],
      companyName: json["company_name"] ?? "",
      departmentName: json["department_name"] ?? "",
      positionName: json["position_name"] ?? "",
      policyName: json["policy_name"] ?? "",
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "emp_id": empId,
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "gender": gender,
      "company": company,
      "phone": phone,
      "email": email,
      "biller_id": billerId,
      "active": active,
      "avatar": avatar,
      "nationality": nationality,
      "position": position,
      "employeed_date": employeedDate,
      "user_type": userType,
      "basic_salary": basicSalary,
      "is_remote_allow": isRemoteAllow,
      "candidate": candidate,
      "photo": photo,
      "company_name": companyName,
      "department_name": departmentName,
      "position_name": positionName,
      "policy_name": policyName,
      "image": image,
    };
  }
  // full name
  String get fullName {
    return "$firstName $lastName";
  }
}



class CompanyModel {
  final List<CompanyData>? data;
  final int? limit;
  final int? start;
  final int? total;

  CompanyModel({
    this.data,
    this.limit,
    this.start,
    this.total,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CompanyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: json['limit'] as int?,
      start: json['start'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'limit': limit,
      'start': start,
      'total': total,
    };
  }
}

class CompanyData {
  final dynamic activeInvoice;
  final String? address;
  final String? addressKh;
  final String? age;
  final dynamic agent;
  final dynamic attachment;
  final dynamic billerId;
  final dynamic bloodGroup;
  final dynamic businessType;
  final String? categoryId;
  final String? city;
  final String? closedDate;
  final String? code;
  final dynamic commune;
  final String? company;
  final String? companyKh;
  final dynamic contactPerson;
  final String? country;
  final dynamic countryId;
  final dynamic createdBy;
  final dynamic creditLimit;
  final dynamic creditTerm;
  final dynamic customerImage;
  final dynamic customerLimit;
  final String? date;
  final dynamic district;
  final String? email;
  final String? endDate;
  final dynamic findConsumerComission;
  final String? gender;
  final String? invoiceFooter;
  final String? languageInvoice;
  final String? latitude;
  final dynamic leadColor;
  final String? leadConvert;
  final dynamic leadGroup;
  final String? leader;
  final dynamic levelId;
  final String? logo;
  final String? longitude;
  final dynamic memberExpiry;
  final String? name;
  final String? nameKh;
  final dynamic nssfNumber;
  final dynamic orderNo;
  final dynamic paidBy;
  final dynamic parentId;
  final String? phone;
  final dynamic postalCode;
  final dynamic products;
  final dynamic projects;
  final String? qrCode;
  final String? radius;
  final String? savePoint;
  final String? serviceFee;
  final dynamic servicePackage;
  final dynamic source;
  final String? state;
  final String? status;
  final dynamic streetId;
  final dynamic streetNo;
  final dynamic studentId;
  final dynamic subcategoryId;
  final dynamic supplierGroupId;
  final dynamic supplierGroupName;
  final dynamic vat;
  final String? vatIt;
  final String? vatNo;
  final dynamic village;
  final String? warehouseId;
  final String? workingDay;
  final dynamic zoneId;

  CompanyData({
    this.activeInvoice,
    this.address,
    this.addressKh,
    this.age,
    this.agent,
    this.attachment,
    this.billerId,
    this.bloodGroup,
    this.businessType,
    this.categoryId,
    this.city,
    this.closedDate,
    this.code,
    this.commune,
    this.company,
    this.companyKh,
    this.contactPerson,
    this.country,
    this.countryId,
    this.createdBy,
    this.creditLimit,
    this.creditTerm,
    this.customerImage,
    this.customerLimit,
    this.date,
    this.district,
    this.email,
    this.endDate,
    this.findConsumerComission,
    this.gender,
    this.invoiceFooter,
    this.languageInvoice,
    this.latitude,
    this.leadColor,
    this.leadConvert,
    this.leadGroup,
    this.leader,
    this.levelId,
    this.logo,
    this.longitude,
    this.memberExpiry,
    this.name,
    this.nameKh,
    this.nssfNumber,
    this.orderNo,
    this.paidBy,
    this.parentId,
    this.phone,
    this.postalCode,
    this.products,
    this.projects,
    this.qrCode,
    this.radius,
    this.savePoint,
    this.serviceFee,
    this.servicePackage,
    this.source,
    this.state,
    this.status,
    this.streetId,
    this.streetNo,
    this.studentId,
    this.subcategoryId,
    this.supplierGroupId,
    this.supplierGroupName,
    this.vat,
    this.vatIt,
    this.vatNo,
    this.village,
    this.warehouseId,
    this.workingDay,
    this.zoneId,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      activeInvoice: json['active_invoice'],
      address: json['address'] as String?,
      addressKh: json['address_kh'] as String?,
      age: json['age'] as String?,
      agent: json['agent'],
      attachment: json['attachment'],
      billerId: json['biller_id'],
      bloodGroup: json['blood_group'],
      businessType: json['business_type'],
      categoryId: json['category_id'] as String?,
      city: json['city'] as String?,
      closedDate: json['closed_date'] as String?,
      code: json['code'] as String?,
      commune: json['commune'],
      company: json['company'] as String?,
      companyKh: json['company_kh'] as String?,
      contactPerson: json['contact_person'],
      country: json['country'] as String?,
      countryId: json['country_id'],
      createdBy: json['created_by'],
      creditLimit: json['credit_limit'],
      creditTerm: json['credit_term'],
      customerImage: json['customer_image'],
      customerLimit: json['customer_limit'],
      date: json['date'] as String?,
      district: json['district'],
      email: json['email'] as String?,
      endDate: json['end_date'] as String?,
      findConsumerComission: json['find_consumer_comission'],
      gender: json['gender'] as String?,
      invoiceFooter: json['invoice_footer'] as String?,
      languageInvoice: json['language_invoice'] as String?,
      latitude: json['latitude'] as String?,
      leadColor: json['lead_color'],
      leadConvert: json['lead_convert'] as String?,
      leadGroup: json['lead_group'],
      leader: json['leader'] as String?,
      levelId: json['level_id'],
      logo: json['logo'] as String?,
      longitude: json['longitude'] as String?,
      memberExpiry: json['member_expiry'],
      name: json['name'] as String?,
      nameKh: json['name_kh'] as String?,
      nssfNumber: json['nssf_number'],
      orderNo: json['order_no'],
      paidBy: json['paid_by'],
      parentId: json['parent_id'],
      phone: json['phone'] as String?,
      postalCode: json['postal_code'],
      products: json['products'],
      projects: json['projects'],
      qrCode: json['qr_code'] as String?,
      radius: json['radius'] as String?,
      savePoint: json['save_point'] as String?,
      serviceFee: json['service_fee'] as String?,
      servicePackage: json['service_package'],
      source: json['source'],
      state: json['state'] as String?,
      status: json['status'] as String?,
      streetId: json['street_id'],
      streetNo: json['street_no'],
      studentId: json['student_id'],
      subcategoryId: json['subcategory_id'],
      supplierGroupId: json['supplier_group_id'],
      supplierGroupName: json['supplier_group_name'],
      vat: json['vat'],
      vatIt: json['vat_it'] as String?,
      vatNo: json['vat_no'] as String?,
      village: json['village'],
      warehouseId: json['warehouse_id'] as String?,
      workingDay: json['working_day'] as String?,
      zoneId: json['zone_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_invoice': activeInvoice,
      'address': address,
      'address_kh': addressKh,
      'age': age,
      'agent': agent,
      'attachment': attachment,
      'biller_id': billerId,
      'blood_group': bloodGroup,
      'business_type': businessType,
      'category_id': categoryId,
      'city': city,
      'closed_date': closedDate,
      'code': code,
      'commune': commune,
      'company': company,
      'company_kh': companyKh,
      'contact_person': contactPerson,
      'country': country,
      'country_id': countryId,
      'created_by': createdBy,
      'credit_limit': creditLimit,
      'credit_term': creditTerm,
      'customer_image': customerImage,
      'customer_limit': customerLimit,
      'date': date,
      'district': district,
      'email': email,
      'end_date': endDate,
      'find_consumer_comission': findConsumerComission,
      'gender': gender,
      'invoice_footer': invoiceFooter,
      'language_invoice': languageInvoice,
      'latitude': latitude,
      'lead_color': leadColor,
      'lead_convert': leadConvert,
      'lead_group': leadGroup,
      'leader': leader,
      'level_id': levelId,
      'logo': logo,
      'longitude': longitude,
      'member_expiry': memberExpiry,
      'name': name,
      'name_kh': nameKh,
      'nssf_number': nssfNumber,
      'order_no': orderNo,
      'paid_by': paidBy,
      'parentId': parentId,
      'phone': phone,
      'postal_code': postalCode,
      'products': products,
      'projects': projects,
      'qr_code': qrCode,
      'radius': radius,
      'save_point': savePoint,
      'service_fee': serviceFee,
      'service_package': servicePackage,
      'source': source,
      'state': state,
      'status': status,
      'street_id': streetId,
      'street_no': streetNo,
      'student_id': studentId,
      'subcategoryId': subcategoryId,
      'supplier_group_id': supplierGroupId,
      'supplier_group_name': supplierGroupName,
      'vat': vat,
      'vat_it': vatIt,
      'vat_no': vatNo,
      'village': village,
      'warehouse_id': warehouseId,
      'working_day': workingDay,
      'zone_id': zoneId,
    };
  }
}