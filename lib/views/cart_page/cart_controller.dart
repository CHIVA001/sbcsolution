import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../home_page/models/product_model.dart';

class CartController extends GetxController {
  final _storage = GetStorage();

  // key = product.id, value = Map with product and quantity (RxInt)
  var cartItems = <int, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void addToCart(ProductModel product) {
    final id = int.parse(product.id);
    if (cartItems.containsKey(id)) {
      final quantity = cartItems[id]!['quantity'] as RxInt;
      quantity.value++;
    } else {
      cartItems[id] = {'product': product, 'quantity': 1.obs};
    }
    saveCart();
  }

  void removeFromCart(ProductModel product) {
    final id = int.parse(product.id);
    if (cartItems.containsKey(id)) {
      final quantity = cartItems[id]!['quantity'] as RxInt;
      if (quantity.value > 1) {
        quantity.value--;
      } else {
        quantity.value = 1;
      }
    }
    saveCart();
  }

  void removeItem(ProductModel product) {
    final id = int.parse(product.id);
    if (cartItems.containsKey(id)) {
      cartItems.remove(id);
      saveCart();
    }
  }

  void clearCart() {
    cartItems.clear();
    saveCart();
  }

  int get totalItems => cartItems.values.fold<int>(0, (sum, item) {
    final quantity = item['quantity'];
    if (quantity is RxInt) {
      return sum + quantity.value;
    }
    return sum + (quantity ?? 0) as int;
  });

  double get totalPrice => cartItems.values.fold(
    0,
    (sum, item) =>
        sum +
        (double.tryParse(item['product'].price) ?? 0) *
            (item['quantity'] as RxInt).value,
  );

  void saveCart() {
    final data = cartItems.map(
      (key, value) => MapEntry(key.toString(), {
        'id': value['product'].id,
        'name': value['product'].name,
        'price': value['product'].price,
        'imageUrl': value['product'].imageUrl,
        'quantity': (value['quantity'] as RxInt).value,
      }),
    );
    _storage.write('cart', data);
  }

  void loadCart() {
    final data = _storage.read<Map>('cart');
    if (data != null) {
      cartItems.assignAll(
        data.map((key, value) {
          final product = ProductModel(
            id: value['id'].toString(),
            code: value['code']?.toString() ?? '',
            name: value['name'] ?? '',
            imageUrl: value['imageUrl'] ?? '',
            price: value['price'].toString(),
            netPrice: value['net_price']?.toString() ?? '0',
            unitPrice: value['unit_price']?.toString() ?? '0',
            brand: null,
            category: null,
            multiUnit: [],
          );

          // wrap quantity in RxInt safely
          final qty = value['quantity'] != null
              ? RxInt(int.tryParse(value['quantity'].toString()) ?? 1)
              : 1.obs;

          return MapEntry(int.parse(key), {
            'product': product,
            'quantity': qty,
          });
        }),
      );
    }
  }
}
