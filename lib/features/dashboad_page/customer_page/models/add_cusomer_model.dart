class LocationModel {
  final String name;
  final String address;
  final String city;
  final String phone;
  final String latitude;
  final String longitude;

  LocationModel({
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }
}

class AddCustomerModel {
  final String date;
  final int customerGroupId;
  final int priceGroupId;
  final String? company;
  final String name;
  final String phone;
  final String? email;
  final String? city;
  final String? note;
  final String? address;
  final String gender;
  final int savePoint;
  final List<LocationModel> locations;

  AddCustomerModel({
    required this.date,
    required this.customerGroupId,
    required this.priceGroupId,
    this.company,
    required this.name,
    required this.phone,
    this.email,
    this.city,
    this.note,
    this.address,
    required this.gender,
    required this.savePoint,
    required this.locations,
  });

  Map<String, dynamic> toJson() => {
    "date": date,
    "customer_group_id": customerGroupId,
    "price_group_id": priceGroupId,
    "company": company,
    "name": name,
    "phone": phone,
    "email": email,
    "city": city,
    "note": note,
    "address": address,
    "gender": gender,
    "save_point": savePoint,
    "locations": locations.map((e) => e.toJson()).toList(),
  };
}
