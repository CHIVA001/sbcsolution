import 'package:cyspharama_app/routes/app_routes.dart';

import '../../core/themes/app_style.dart';
import '../../widgets/build_app_bar.dart';
import '/core/themes/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/cart_controller.dart';
import 'controllers/product_controller.dart';
import 'models/product_model.dart';
import 'products_page.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({super.key, required this.product});

  final ProductModel product;
  final _controller = Get.find<ProductsController>();
  final _cartCtr = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: product.name),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Hero(
                    tag: 'pro_${product.id}',
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      color: AppColors.bgColorLight,

                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(product.name, style: textBold()),
                              ),
                              Text(
                                '\$${product.price}',
                                style: textBold().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 24.0,
                                ),
                              ),
                            ],
                          ),
                          // star
                        ),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  color: AppColors.accentColor,
                                );
                              }),
                            ),
                            Text(' (5.0)', style: textMeduim()),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        _buildRowText(
                          value: 'Category',
                          title: '${product.category?.name}',
                        ),
                        Divider(),
                        _buildRowText(value: 'Code', title: '${product.code}'),
                        Divider(),
                        _buildRowText(
                          value: 'Unit',
                          title: product.unit.isNotEmpty
                              ? product.unit.first.name
                              : '',
                        ),
                        Divider(),
                        _buildRowText(value: 'Slug', title: '${product.slug}'),
                        Divider(),
                        _buildRowText(value: 'Type', title: '${product.type}'),
                        Divider(),
                        _buildRowText(
                          value: 'Options',
                          title: '${product.options}',
                        ),
                        // Similar products section
                        SizedBox(height: 24.0),
                        Text(
                          'Similar Prosucts',
                          style: textBold().copyWith(fontSize: 20.0),
                        ),
                        _buildSimilar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Quantity selector
                Obx(() {
                  final index = _cartCtr.cartItems.indexWhere(
                    (item) => item.id == product.id,
                  );
                  final qty = index != -1 ? _cartCtr.cartItems[index].qty : 1;

                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (index != -1) {
                            _cartCtr.decrementQty(_cartCtr.cartItems[index]);
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text(qty.toString(), style: textMeduim()),
                      IconButton(
                        onPressed: () {
                          if (index != -1) {
                            _cartCtr.incrementQty(_cartCtr.cartItems[index]);
                          } else {
                            _cartCtr.addToCart(product);
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  );
                }),

                const SizedBox(width: 8.0),

                // Checkout button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.confirmCart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size(50, 50.0),
                    ),
                    child: Text(
                      'Check Out',
                      style: textBold().copyWith(color: AppColors.textLight),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Add to cart button
                IconButton(
                  onPressed: () {
                    _cartCtr.addToCart(product);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    minimumSize: const Size(50, 50.0),
                  ),
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Obx(() {
        final similarProducts = _controller.products.where((p) {
          return p.category?.id == product.category?.id && p.id != product.id;
        }).toList();

        final displayProducts = similarProducts.isNotEmpty
            ? similarProducts
            : _controller.products
                  .where((p) => p.id != product.id)
                  .take(5)
                  .toList();

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayProducts.length,
            itemBuilder: (context, index) {
              final sp = displayProducts[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed('${AppRoutes.product}/${sp.id}');
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    color: AppColors.bgColorLight,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: sp.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sp.name,
                              style: textdefualt().copyWith(fontSize: 14.0),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${sp.price}',
                              style: textBold().copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 15.0,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildRowText({required String value, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value: ',
            style: textMeduim().copyWith(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(child: Text(title, style: textdefualt())),
        ],
      ),
    );
  }
}
