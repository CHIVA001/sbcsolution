import 'package:cyspharama_app/core/themes/app_style.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/build_app_bar.dart';
import '../../../widgets/build_counter.dart';
import '../../../widgets/cached_image.dart';
import '../controllers/cart_controller.dart';
import '../products_page.dart';
import '/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final _cartCtr = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Cart'),
      body: Obx(() {
        if (_cartCtr.cartItems.isEmpty) {
          return Center(child: Text('Cart(0)'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cartCtr.cartItems.length,
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final cart = _cartCtr.cartItems[index];
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16.0),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,

                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageProduct(
                            imageUrl: cart.imageUrl,
                            width: 90,
                            height: 90,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6.0),
                                Text(
                                  cart.name,
                                  style: textdefualt().copyWith(
                                    fontSize: 15.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(
                                  child: Text(
                                    '\$${cart.price}',
                                    style: textdefualt().copyWith(
                                      fontSize: 15.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BuildCounter(
                                        padding: EdgeInsets.all(0),
                                        height: 30,
                                        qty: cart.qty.toString(),
                                        bgColor: Colors.transparent,
                                        onPressedAdd: () =>
                                            _cartCtr.incrementQty(cart),
                                        onPressedRemove: () =>
                                            _cartCtr.decrementQty(cart),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _cartCtr.removeItem(cart),
                                        icon: Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: AppColors.dangerColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //////////////////
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: AppColors.lightGrey,
                    offset: Offset(0, 2),
                  ),
                ],
                color: AppColors.textLight,
              ),
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text('Total item:', style: textMeduim()),
                      Spacer(),
                      Text(
                        _cartCtr.totalItems.value.toString(),
                        style: textdefualt(),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('Total Products:', style: textMeduim()),
                      Spacer(),
                      Text(
                        _cartCtr.cartItems.length.toString(),
                        style: textdefualt(),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('Total Price:', style: textMeduim()),
                      Spacer(),
                      Text(
                        '\$${_cartCtr.grandTotal.value.toStringAsFixed(2)}',
                        style: textdefualt(),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.confirmCart),
                    style: IconButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text(
                      'Check Out',
                      style: textMeduim().copyWith(
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
