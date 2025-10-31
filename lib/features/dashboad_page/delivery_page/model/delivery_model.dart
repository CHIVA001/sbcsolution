class DeliveryModel {
  final bool status;
  final String message;
  final DeliveryData? data;

  DeliveryModel({required this.status, required this.message, this.data});

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? DeliveryData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class DeliveryData {
  final String id;
  final String invoiceDate;
  final String referenceNo;
  final String status;
  final String subTotal;
  final String createdBy;
  final String? updatedBy;
  final String? updatedAt;
  final String deliveryId;
  final String paymentTerm;
  final String zoneId;
  final String customer;
  final String? attachment;

  DeliveryData({
    required this.id,
    required this.invoiceDate,
    required this.referenceNo,
    required this.status,
    required this.subTotal,
    required this.createdBy,
    this.updatedBy,
    this.updatedAt,
    required this.deliveryId,
    required this.paymentTerm,
    required this.zoneId,
    required this.customer,
    this.attachment,
  });

  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
      id: json['id'] ?? '',
      invoiceDate: json['invoice_date'] ?? '',
      referenceNo: json['reference_no'] ?? '',
      status: json['status'] ?? '',
      subTotal: json['sub_total'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      updatedAt: json['updated_at'],
      deliveryId: json['delivery_id'] ?? '',
      paymentTerm: json['payment_term'] ?? '',
      zoneId: json['zone_id'] ?? '',
      customer: json['customer'] ?? '',
      attachment: json['attachment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': invoiceDate,
      'reference_no': referenceNo,
      'status': status,
      'grand_total': subTotal,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'updated_at': updatedAt,
      'delivery_id': deliveryId,
      'payment_term': paymentTerm,
      'zone_id': zoneId,
      'customer': customer,
      'attachment': attachment,
    };
  }
}
