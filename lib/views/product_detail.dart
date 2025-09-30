import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/views/home_page/models/product_model.dart';
import 'cart_page/cart_controller.dart';

class ProductDetail extends StatelessWidget {
  final ProductModel product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartCtr = Get.put(CartController());
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sizeWidth > 600 ? 24 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.lightBgLight,
                ),
                child: Hero(
                  tag: product.id,
                  child: CachedNetworkImage(
                    imageUrl:
                        (product.imageUrl.isNotEmpty &&
                            !["null", "No Tax"].contains(product.imageUrl))
                        ? product.imageUrl
                        : "https://cdn.watter.dk/product/no-image-available.png",
                    height: sizeWidth > 600 ? 400 : 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/notfound.png'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              product.name,
              style: TextStyle(
                fontSize: sizeWidth > 600 ? 26 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Price
            Text(
              "\$${product.price}",
              style: TextStyle(
                fontSize: sizeWidth > 600 ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            if (product.brand != null)
              buildText(
                title: 'Brand',
                value: '${product.brand?.name}',
                sizeWidth: sizeWidth,
              ),
            if (product.category != null)
              buildText(
                title: 'Category',
                value: '${product.category?.name}',
                sizeWidth: sizeWidth,
              ),
            buildText(title: 'Code', value: product.code, sizeWidth: sizeWidth),
            if (product.slug != null)
              buildText(
                title: 'Slung',
                value: product.slug!,
                sizeWidth: sizeWidth,
              ),
          ],
        ),
      ),

      //  Bottom Add to Cart button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.lightBgLight,
              size: 24.0,
            ),
            label: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 18, color: AppColors.lightBgLight),
            ),
            onPressed: () {
              cartCtr.addToCart(product);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Add to cart')));
            },
          ),
        ),
      ),
    );
  }

  Widget buildText({
    required String title,
    required String value,
    required double sizeWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: sizeWidth > 600 ? 18 : 16.0,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: sizeWidth > 600 ? 18 : 16.0,
              fontWeight: FontWeight.w400,
              color: AppColors.darkBg,
            ),
          ),
        ],
      ),
    );
  }
}
