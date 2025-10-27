class CustomerModel {
  final int id;
  final String code;
  final String name;
  final String? nameKh;
  final String email;
  final String phone;
  final String? gender;
  final int? age;
  final String customerGroupName;
  final String priceGroupName;
  final String? attachmentUrl;
  final String status;
  final String? address;
  final String? creditTerm;
  final double? creditLimit;
  final int activeInvoice;
  final String? vatNo;
  final String? contactPerson;
  final String? createdBy;
  final String? city;
  final String? district;
  final String? commune;
  final String? village;
  final String? streetNo;

  CustomerModel({
    required this.id,
    required this.code,
    required this.name,
    this.nameKh,
    required this.email,
    required this.phone,
    this.gender,
    this.age,
    required this.customerGroupName,
    this.attachmentUrl,
    required this.status,
    this.address,
    this.creditTerm,
    this.creditLimit,
    required this.activeInvoice,
    this.vatNo,
    this.contactPerson,
    this.createdBy,
    this.city,
    this.district,
    this.commune,
    this.village,
    this.streetNo,
    required this.priceGroupName,
  });

  // ✅ Parse from JSON (GET)
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: _safeParseInt(json['id']),
      code: _safeParseString(json['code']),
      name: _safeParseString(json['name']),
      nameKh: _safeParseString(json['name_kh']),
      email: _safeParseString(json['email']),
      phone: _safeParseString(json['phone']),
      gender: _safeParseString(json['gender']),
      age: int.tryParse(json['age']?.toString() ?? ''),
      customerGroupName: _safeParseString(json['customer_group_name']),
      priceGroupName: _safeParseString(json['price_group_name']),
      attachmentUrl: _safeParseString(json['attachment']),
      status: _safeParseString(json['status']),
      address: _safeParseString(json['address']),
      creditTerm: _safeParseString(json['credit_term']),
      creditLimit: double.tryParse(json['credit_limit']?.toString() ?? ''),
      activeInvoice: _safeParseInt(json['active_invoice']),
      vatNo: _safeParseString(json['vat_no']),
      contactPerson: _safeParseString(json['contact_person']),
      createdBy: _safeParseString(json['created_by']),
      city: _safeParseString(json['city']),
      district: _safeParseString(json['district']),
      commune: _safeParseString(json['commune']),
      village: _safeParseString(json['village']),
      streetNo: _safeParseString(json['street_no']),
    );
  }

  // ✅ Convert to JSON (POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "name_kh": nameKh,
      "email": email,
      "phone": phone,
      "gender": gender,
      "age": age,
      "customer_group_name": customerGroupName,
      "attachment": attachmentUrl,
      "status": status,
      "address": address,
      "credit_term": creditTerm,
      "credit_limit": creditLimit,
      "active_invoice": activeInvoice,
      "vat_no": vatNo,
      "contact_person": contactPerson,
      "created_by": createdBy,
      "city": city,
      "district": district,
      "commune": commune,
      "village": village,
      "street_no": streetNo,
    };
  }

  // ✅ Create a copy of this model (useful for updating data)
  CustomerModel copyWith({
    int? id,
    String? code,
    String? name,
    String? nameKh,
    String? email,
    String? phone,
    String? gender,
    int? age,
    String? customerGroupName,
    String? attachmentUrl,
    String? status,
    String? address,
    String? creditTerm,
    double? creditLimit,
    int? activeInvoice,
    String? vatNo,
    String? contactPerson,
    String? createdBy,
    String? city,
    String? district,
    String? commune,
    String? village,
    String? streetNo,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameKh: nameKh ?? this.nameKh,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      customerGroupName: customerGroupName ?? this.customerGroupName,
      priceGroupName: priceGroupName,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      status: status ?? this.status,
      address: address ?? this.address,
      creditTerm: creditTerm ?? this.creditTerm,
      creditLimit: creditLimit ?? this.creditLimit,
      activeInvoice: activeInvoice ?? this.activeInvoice,
      vatNo: vatNo ?? this.vatNo,
      contactPerson: contactPerson ?? this.contactPerson,
      createdBy: createdBy ?? this.createdBy,
      city: city ?? this.city,
      district: district ?? this.district,
      commune: commune ?? this.commune,
      village: village ?? this.village,
      streetNo: streetNo ?? this.streetNo,
    );
  }

  // ✅ Parse list of customers (GET multiple)
  static List<CustomerModel> fromList(List<dynamic> list) {
    return list.map((e) => CustomerModel.fromJson(e)).toList();
  }

  // ✅ For easy debugging
  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone, email: $email, city: $city, status: $status)';
  }
}

// 🔒 Safe parse helpers
int _safeParseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _safeParseString(dynamic value) {
  return value?.toString() ?? '';
}
