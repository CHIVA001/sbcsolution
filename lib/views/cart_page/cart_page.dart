import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:remixicon/remixicon.dart';
import '../../widgets/build_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../constants/app_color.dart';
import 'cart_controller.dart';
import 'check_out_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCtr = Get.put(CartController());

    return Scaffold(
      backgroundColor: AppColors.lightBgLight,
      appBar: buildAppBar(),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24.0, 16, 0),
        child: Obx(() {
          final items = cartCtr.cartItems.values.toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shopping Cart',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBg,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${cartCtr.cartItems.length} ${cartCtr.cartItems.length > 1 ? "items" : "item"}',
                style: TextStyle(fontSize: 16.0, color: AppColors.darkBg),
              ),
              Divider(color: AppColors.darkBg),
              SizedBox(height: 8.0),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text("Your cart is empty"))
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final product = items[index]['product'];
                          final quantity = items[index]['quantity'] as RxInt;

                          return Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.lightBgLight,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.darkTextMuted,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrl,
                                    fit: BoxFit.fitHeight,
                                    placeholder: (_, __) => SizedBox.shrink(),
                                    errorWidget: (_, __, ___) =>
                                        Image.asset('assets/notfound.png'),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product.name,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  cartCtr.removeItem(product),
                                              child: Icon(
                                                RemixIcons.delete_bin_6_line,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              '\$${product.price}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: AppColors.lightBgDark,
                                              ),
                                              child: Obx(
                                                () => Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () => cartCtr
                                                          .removeFromCart(
                                                            product,
                                                          ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    SizedBox(width: 14),
                                                    Text(
                                                      '${quantity.value}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(width: 14),
                                                    InkWell(
                                                      onTap: () => cartCtr
                                                          .addToCart(product),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
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
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: \$${cartCtr.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () => Get.to(
                          () => CheckOutPage(),
                          transition: Transition.rightToLeft,
                        ),
                        child: Text(
                          "Checkout",
                          style: TextStyle(color: AppColors.lightBgLight),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
