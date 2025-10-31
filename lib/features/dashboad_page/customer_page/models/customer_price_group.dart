class CustomerPriceGroupModel {
  final String id;
  final String name;
  final String type;

  CustomerPriceGroupModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory CustomerPriceGroupModel.fromJson(Map<String, dynamic> json) {
    return CustomerPriceGroupModel(
      id: json['id']??0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
