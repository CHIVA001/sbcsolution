class CategoryModel {
  final String id;
  final String code;
  final String name;
  final String image;
  final String parentId;
  final String slug;
  final String description;
  final String status;
  final String order;

  CategoryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.parentId,
    required this.slug,
    required this.description,
    required this.status,
    required this.order,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      parentId: json['parent_id'],
      slug: json['slug'],
      description: json['description'],
      status: json['status'],
      order: json['order'],
    );
  }
}
