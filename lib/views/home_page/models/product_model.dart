import 'brand_model.dart';
import 'category_model.dart';

class ProductModel {
  final String id;
  final String code;
  final String name;
  final String imageUrl;
  final String price;
  final String netPrice;
  final String? slug;
  final String unitPrice;
  final String? type;
  final BrandModel? brand;

  final CategoryModel? category;
  final List<MultiUnit> multiUnit;

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.netPrice,
    required this.unitPrice,
    this.type,
    this.brand,
    this.slug,
    this.category, // nullable
    required this.multiUnit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      slug: json['slug'] ?? '',
      price: json['price']?.toString() ?? '0',
      netPrice: json['net_price']?.toString() ?? '0',
      unitPrice: json['unit_price']?.toString() ?? '0',
      type: json['type'] ?? '',
      brand: json['brand'] != null ? BrandModel.fromJson(json['brand']) : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,

      multiUnit: (json['multi_unit'] as List? ?? [])
          .map((e) => MultiUnit.fromJson(e))
          .toList(),
    );
  }
}

class MultiUnit {
  final String id;
  final String productId;
  final String unitId;
  final String cost;
  final String price;
  final String name;

  MultiUnit({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.cost,
    required this.price,
    required this.name,
  });

  factory MultiUnit.fromJson(Map<String, dynamic> json) {
    return MultiUnit(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      unitId: json['unit_id']?.toString() ?? '',
      cost: json['cost']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      name: json['name'] ?? 'Unit',
    );
  }
}
