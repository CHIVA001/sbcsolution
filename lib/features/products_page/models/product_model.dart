import 'category_model.dart';

class ProductModel {
  final bool addonItems;
  final CategoryModel? category;
  final String code;
  final String id;
  final String imageUrl;
  final List<MultiUnit> multiUnit;
  final String name;
  final String netPrice;
  final bool options;
  final String price;
  final String? slug;
  final String taxMethod;
  final String type;
  final List<Unit> unit;
  final String unitPrice;

  ProductModel({
    required this.addonItems,
    this.category,
    required this.code,
    required this.id,
    required this.imageUrl,
    required this.multiUnit,
    required this.name,
    required this.netPrice,
    required this.options,
    required this.price,
    this.slug,
    required this.taxMethod,
    required this.type,
    required this.unit,
    required this.unitPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Convert multi_unit safely
    List<MultiUnit> parseMultiUnit(dynamic data) {
      if (data is List) {
        return data.map((x) => MultiUnit.fromJson(x)).toList();
      } else if (data is Map<String, dynamic>) {
        return [MultiUnit.fromJson(data)];
      }
      return []; // When false or null
    }

    // Convert unit safely
    List<Unit> parseUnit(dynamic data) {
      if (data is List) {
        return data.map((e) => Unit.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        return [Unit.fromJson(data)];
      }
      return [];
    }

    return ProductModel(
      addonItems: json['addon_items'] ?? false,
      category: (json['category'] is Map<String, dynamic>)
          ? CategoryModel.fromJson(json['category'])
          : null,
      code: json['code']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      multiUnit: parseMultiUnit(json['multi_unit']),
      name: json['name']?.toString() ?? '',
      netPrice: json['net_price']?.toString() ?? '',
      // Convert options safely: sometimes it's a list, sometimes false
      options: json['options'] is List ? true : false,
      price: json['price']?.toString() ?? '',
      slug: json['slug']?.toString(),
      taxMethod: json['tax_method']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      unit: parseUnit(json['unit']),
      unitPrice: json['unit_price']?.toString() ?? '',
    );
  }
}

class MultiUnit {
  final String id;
  final String productId;
  final String unitId;
  final String cost;
  final String price;
  final String? productCode;
  final String unitPrice;
  final String code;
  final String name;
  final String? baseUnit;
  final String? operator;
  final String? unitValue;
  final String? operationValue;
  final String proCode;
  final String proUnit;

  MultiUnit({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.cost,
    required this.price,
    this.productCode,
    required this.unitPrice,
    required this.code,
    required this.name,
    this.baseUnit,
    this.operator,
    this.unitValue,
    this.operationValue,
    required this.proCode,
    required this.proUnit,
  });

  factory MultiUnit.fromJson(Map<String, dynamic> json) => MultiUnit(
    id: json['id']?.toString() ?? '',
    productId: json['product_id']?.toString() ?? '',
    unitId: json['unit_id']?.toString() ?? '',
    cost: json['cost']?.toString() ?? '',
    price: json['price']?.toString() ?? '',
    productCode: json['product_code']?.toString() ?? '',
    unitPrice: json['unit_price']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    baseUnit: json['base_unit']?.toString() ?? '',
    operator: json['operator']?.toString() ?? '',
    unitValue: json['unit_value']?.toString() ?? '',
    operationValue: json['operation_value']?.toString() ?? '',
    proCode: json['pro_code']?.toString() ?? '',
    proUnit: json['pro_unit']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'unit_id': unitId,
    'cost': cost,
    'price': price,
    'product_code': productCode,
    'unit_price': unitPrice,
    'code': code,
    'name': name,
    'base_unit': baseUnit,
    'operator': operator,
    'unit_value': unitValue,
    'operation_value': operationValue,
    'pro_code': proCode,
    'pro_unit': proUnit,
  };
}

class TaxRate {
  final String id;
  final String name;
  final String code;
  final String rate;
  final String type;

  TaxRate({
    required this.id,
    required this.name,
    required this.code,
    required this.rate,
    required this.type,
  });
}

class Unit {
  final String id;
  final String code;
  final String name;
  final String? baseUnit;
  final String? operator;
  final String? unitValue;
  final String? operationValue;

  Unit({
    required this.id,
    required this.code,
    required this.name,
    this.baseUnit,
    this.operator,
    this.unitValue,
    this.operationValue,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    baseUnit: json['base_unit'],
    operator: json['operator'],
    unitValue: json['unit_value'],
    operationValue: json['operation_value'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'base_unit': baseUnit,
    'operator': operator,
    'unit_value': unitValue,
    'operation_value': operationValue,
  };
}
