import '../../products_page/models/product_model.dart';

class CartItemModel {
  final String id;
  final String code;
  final String name;
  final String imageUrl;
  final double price;
  final double total;
  final double subTotal;
  final double discount;
  final String productUnit;
  final List<dynamic> addonItems;
  int qty;

  CartItemModel({
    required this.id,
    required this.code,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.qty,
    required this.total,
    required this.subTotal,
    this.discount = 0.0,
    this.productUnit = 'unit',
    this.addonItems = const [],
  });

  factory CartItemModel.fromProduct(ProductModel product, int qty) {
    final price = double.tryParse(product.price) ?? 0.0;
    return CartItemModel(
      id: product.id,
      code: product.code,
      name: product.name,
      imageUrl: product.imageUrl,
      price: price,
      qty: qty,
      total: price * qty,
      subTotal: price * qty,
      discount: 0.0,
      productUnit:
          product.unit.isNotEmpty ? product.unit.first.name : 'unit',
      addonItems: [],
    );
  }

  CartItemModel copyWith({
    int? qty,
  }) {
    final newQty = qty ?? this.qty;
    final newTotal = price * newQty;
    return CartItemModel(
      id: id,
      code: code,
      name: name,
      imageUrl: imageUrl,
      price: price,
      qty: newQty,
      total: newTotal,
      subTotal: newTotal,
      discount: discount,
      productUnit: productUnit,
      addonItems: addonItems,
    );
  }

  /// 🔄 For local storage (SharedPreferences)
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'qty': qty,
        'total': total,
        'sub_total': subTotal,
        'discount': discount,
        'product_unit': productUnit,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'].toString(),
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num).toDouble(),
      qty: json['qty'] ?? 1,
      total: (json['total'] as num).toDouble(),
      subTotal: (json['sub_total'] as num).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      productUnit: json['product_unit'] ?? 'unit',
    );
  }

  /// 🧾 For API posting format
  Map<String, dynamic> toApiJson() => {
        "product_id": id,
        "product_code": code,
        "addon_items": addonItems,
        "price": price,
        "quantity": qty,
        "product_unit": productUnit,
        "discount": discount,
        "total": total,
        "sub_total": subTotal,
      };
}
