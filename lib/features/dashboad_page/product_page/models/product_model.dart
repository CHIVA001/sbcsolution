// import 'dart:convert';

String? _safeParseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;

  return value.toString();
}

double _safeParseDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

int _safeParseInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}

class ProductResponse {
  final List<ProductModel> data;
  final int limit;
  final int start;
  final int total;

  ProductResponse({
    required this.data,
    required this.limit,
    required this.start,
    required this.total,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      limit: _safeParseInt(json['limit']),
      start: _safeParseInt(json['start']),
      total: _safeParseInt(json['total']),
    );
  }
}

class ProductModel {
  final bool addonItems;
  final String code;
  final int id;
  final String imageUrl;
  final List<MultiUnitModel> multiUnit;
  final String name;
  final double netPrice;
  final bool options;
  final double price;
  final String? slug;
  final String taxMethod;
  final String? taxRate;
  final String type;
  final UnitModel unit;
  final double unitPrice;

  ProductModel({
    required this.addonItems,
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
    this.taxRate,
    required this.type,
    required this.unit,
    required this.unitPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var multiUnitList = <MultiUnitModel>[];
    if (json['multi_unit'] != null && json['multi_unit'] is List) {
      multiUnitList = (json['multi_unit'] as List)
          .map((item) => MultiUnitModel.fromJson(item))
          .toList();
    }

    return ProductModel(
      addonItems: json['addon_items'] ?? false,
      code: _safeParseString(json['code']) ?? '',
      id: _safeParseInt(json['id']),
      imageUrl: _safeParseString(json['image_url']) ?? '',
      multiUnit: multiUnitList,
      name: _safeParseString(json['name']) ?? '',
      netPrice: _safeParseDouble(json['net_price']),
      options: json['options'] ?? false,
      price: _safeParseDouble(json['price']),
      slug: _safeParseString(json['slug']),
      taxMethod: _safeParseString(json['tax_method']) ?? '',
      taxRate: _safeParseString(json['tax_rate']),
      type: _safeParseString(json['type']) ?? '',
      unit: json['unit'] != null && json['unit'] is Map
          ? UnitModel.fromJson(json['unit'])
          : UnitModel.empty(),
      unitPrice: _safeParseDouble(json['unit_price']),
    );
  }
}

class MultiUnitModel {
  final int id;
  final int productId;
  final int unitId;
  final double cost;
  final double price;
  final String? productCode;
  final double unitPrice;
  final String code;
  final String name;
  final String? proCode;
  final int proUnit;

  MultiUnitModel({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.cost,
    required this.price,
    this.productCode,
    required this.unitPrice,
    required this.code,
    required this.name,
    this.proCode,
    required this.proUnit,
  });

  factory MultiUnitModel.fromJson(Map<String, dynamic> json) {
    return MultiUnitModel(
      id: _safeParseInt(json['id']),
      productId: _safeParseInt(json['product_id']),
      unitId: _safeParseInt(json['unit_id']),
      cost: _safeParseDouble(json['cost']),
      price: _safeParseDouble(json['price']),
      productCode: _safeParseString(json['product_code']),
      unitPrice: _safeParseDouble(json['unit_price']),
      code: _safeParseString(json['code']) ?? '',
      name: _safeParseString(json['name']) ?? '',
      proCode: _safeParseString(json['pro_code']),
      proUnit: _safeParseInt(json['pro_unit']),
    );
  }
}

class UnitModel {
  final int id;
  final String code;
  final String name;

  UnitModel({required this.id, required this.code, required this.name});

  factory UnitModel.empty() {
    return UnitModel(id: 0, code: '', name: 'N/A');
  }

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: _safeParseInt(json['id']),
      code: _safeParseString(json['code']) ?? '',
      name: _safeParseString(json['name']) ?? '',
    );
  }
}
