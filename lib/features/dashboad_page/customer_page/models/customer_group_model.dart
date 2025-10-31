class CustomerGroupModel {
  final String id;
  final String name;
  final String percent;

  CustomerGroupModel({
    required this.id,
    required this.name,
    required this.percent,
  });

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) {
    return CustomerGroupModel(
      id: json['id']??0,
      name: json['name']??'',
      percent: json['percent']??'',
    );
  }
}
