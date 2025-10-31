import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../products_page/models/product_model.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble grandTotal = 0.0.obs;
  RxInt totalItems = 0.obs;

  final customerCtr = TextEditingController(text: 'General Customer');
  final billerCtr = TextEditingController(text: 'SBC');
  final cashierCtr = TextEditingController();
  final payment = TextEditingController(text: 'Cash');

  void addToCart(ProductModel product) {
    final index = cartItems.indexWhere((e) => e.id == product.id);
    if (index != -1) {
      final updated = cartItems[index].copyWith(qty: cartItems[index].qty);
      cartItems[index] = updated;
      Get.back();
      // Get.snackbar('Cart', 'Add to carted');
    } else {
      cartItems.add(CartItemModel.fromProduct(product, 1));
    }
    updateTotals();
  }

  void incrementQty(CartItemModel item) {
    final index = cartItems.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(qty: item.qty + 1);
      updateTotals();
    }
  }

  void decrementQty(CartItemModel item) {
    final index = cartItems.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      if (item.qty > 1) {
        cartItems[index] = cartItems[index].copyWith(qty: item.qty - 1);
      }
      // else {
      //   cartItems.removeAt(index);
      // }
      updateTotals();
    }
  }

  void removeItem(CartItemModel item) {
    cartItems.removeWhere((e) => e.id == item.id);
    updateTotals();
  }

  void clearCart() {
    cartItems.clear();
    subTotal.value = 0;
    grandTotal.value = 0;
    totalItems.value = 0;
  }

  void updateTotals() {
    double total = 0;
    int count = 0;
    for (final item in cartItems) {
      total += item.price * item.qty;
      count += item.qty;
    }
    subTotal.value = total;
    grandTotal.value = total;
    totalItems.value = count;
  }

  /// 🧾 API-ready payload
  Map<String, dynamic> toApiJson({
    required String customerId,
    required String billerId,
  }) {
    return {
      "customer_id": customerId,
      "biller_id": billerId,
      "sale_items": cartItems.map((e) => e.toApiJson()).toList(),
      "grand_total": grandTotal.value,
      "total_items": totalItems.value,
    };
  }
}
