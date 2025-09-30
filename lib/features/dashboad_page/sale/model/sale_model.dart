class SaleModel {
  final String id;
  final String customer;
  final String customerId;
  final double grandTotal;
  final String paymentStatus;
  final String saleStatus;
  final String date;
  final String pickNo;
  final List<SaleItemModel> items; // New field
  final PaymentModel payment; // New field
  final Biller biller; // New field
  final CreatedBy createdBy; // New field
  final String note; // New field

  SaleModel({
    required this.id,
    required this.customer,
    required this.customerId,
    required this.grandTotal,
    required this.paymentStatus,
    required this.saleStatus,
    required this.date,
    required this.pickNo,
    required this.items,
    required this.payment,
    required this.biller,
    required this.createdBy,
    required this.note,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? '',
      customer: json['customer'] ?? '',
      customerId: json['customer_id'] ?? '',
      grandTotal: double.tryParse(json['grand_total'] ?? '0') ?? 0.0,
      paymentStatus: json['payment_status'] ?? '',
      saleStatus: json['sale_status'] ?? '',
      date: json['date'] ?? '',
      pickNo: json['pick_no'] ?? '',
      items:
          (json['items'] as List?)
              ?.map((e) => SaleItemModel.fromJson(e))
              .toList() ??
          [],
      payment: PaymentModel.fromJson(json['payment'] ?? {}),
      biller: Biller.fromJson(json['biller'] ?? {}),
      createdBy: CreatedBy.fromJson(json['created_by'] ?? {}),
      note: json['note'] ?? '',
    );
  }
}

class Biller {
  final String id;
  final String code;
  final String name;
  final String company;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String country;
  final String logo;
  final String vatNo;
  final String latitude;
  final String longitude;

  Biller({
    required this.id,
    required this.code,
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.country,
    required this.logo,
    required this.vatNo,
    required this.latitude,
    required this.longitude,
  });

  factory Biller.fromJson(Map<String, dynamic> json) {
    return Biller(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      logo: json['logo'] ?? '',
      vatNo: json['vat_no'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }
}

class CreatedBy {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String gender;
  final String? avatarUrl;

  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.gender,
    this.avatarUrl,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      gender: json['gender'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }
}

class SaleItemModel {
  final String productName;
  final double quantity;
  final double unitPrice;
  final double subTotal;

  SaleItemModel({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      productName: json['product_name'] ?? '',
      quantity: double.tryParse(json['quantity']?.toString() ?? '0') ?? 0.0,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      subTotal: double.tryParse(json['sub_total']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class PaymentModel {
  final String method;
  final double amount;
  final double change;

  PaymentModel({
    required this.method,
    required this.amount,
    required this.change,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      method: json['method'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      change: double.tryParse(json['change']?.toString() ?? '0') ?? 0.0,
    );
  }
}
