class CustomerModel {
  final int id;
  final String code;
  final String name;
  final String? nameKh;
  final String email;
  final String phone;
  final String? gender;
  final int? age; // Age can be null in your data, so it's a nullable int
  final String customerGroupName;
  final String? attachmentUrl;
  final String status;
  final String? address; // Address can be null
  final String? creditTerm; // Can be null
  final double? creditLimit; // Use double for monetary values and can be null
  final int activeInvoice;
  final String? vatNo; // VAT number can be null
  final String? contactPerson; // New field from your data
  final String? createdBy; // New field
  final String? city; // New field
  final String? district; // New field
  final String? commune; // New field
  final String? village; // New field
  final String? streetNo; // New field

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
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: _safeParseInt(json['id']),
      code: _safeParseString(json['code']),
      name: _safeParseString(json['name']),
      nameKh: _safeParseString(json['name_kh']),
      email: _safeParseString(json['email']),
      phone: _safeParseString(json['phone']),
      gender: _safeParseString(json['gender']),
      age: int.tryParse(json['age'].toString()),
      customerGroupName: _safeParseString(json['customer_group_name']),
      attachmentUrl: json['attachment'],
      status: _safeParseString(json['status']),
      address: _safeParseString(json['address']),
      creditTerm: _safeParseString(json['credit_term']),
      creditLimit: double.tryParse(json['credit_limit'].toString()),
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
}

int _safeParseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _safeParseString(dynamic value) {
  return value?.toString() ?? '';
}