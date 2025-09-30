class BrandModel {
  final String id;
  final String code;
  final String name;
  final String? image;
  final String slug;
  final String order;
  final String description;

  BrandModel({
    required this.id,
    required this.code,
    required this.name,
    this.image,
    required this.slug,
    required this.order,
    required this.description,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      slug: json['slug'],
      order: json['order'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'image': image,
        'slug': slug,
        'order': order,
        'description': description,
      };
}
