class CategoryModel {
  final String id;
  final String code;
  final String name;
  final String? image;
  final String parentId;
  final String slug;
  final String orderNumber;
  final String description;
  final String? billerId;
  final String status;

  CategoryModel({
    required this.id,
    required this.code,
    required this.name,
    this.image,
    required this.parentId,
    required this.slug,
    required this.orderNumber,
    required this.description,
    this.billerId,
    required this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      parentId: json['parent_id'] ?? '0',
      slug: json['slug'] ?? '',
      orderNumber: json['order_number'] ?? '0',
      description: json['description'] ?? '',
      billerId: json['biller_id'],
      status: json['status'] ?? 'show',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'image': image,
      'parent_id': parentId,
      'slug': slug,
      'order_number': orderNumber,
      'description': description,
      'biller_id': billerId,
      'status': status,
    };
  }

}
