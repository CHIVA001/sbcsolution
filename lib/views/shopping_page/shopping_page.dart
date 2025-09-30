import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/widgets/app_drawer.dart';
import 'package:weone_shop/views/home_page/controllers/product_controller.dart';
import 'package:weone_shop/views/product_detail.dart';
import 'package:weone_shop/widgets/build_app_bar.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtr = Get.put(ProductController());

    // ✅ Detect screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ Set column count dynamically
    int crossAxisCount;
    if (screenWidth < 600) {
      // Phones
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      // Small tablets
      crossAxisCount = 3;
    } else {
      // Large tablets
      crossAxisCount = 4;
    }

    return Scaffold(
      appBar: buildAppBar(),
      drawer: const AppDrawer(),
      body: Obx(() {
        if (productCtr.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productCtr.error.isNotEmpty) {
          return Center(
            child: Text(
              productCtr.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (productCtr.products.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productCtr.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: screenWidth < 600 ? 3 / 4 : 4 / 5,
          ),
          itemBuilder: (context, index) {
            final item = productCtr.products[index];
            return GestureDetector(
              onTap: () => Get.to(() => ProductDetail(product: item)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBgLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔥 Image area takes majority height
                    Expanded(
                      flex: 6,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Hero(
                              tag: item.id,
                              // child: CachedNetworkImage(
                              //   imageUrl:
                              //   //     (item.imageUrl.isNotEmpty &&
                              //   //         ![
                              //   //           "null",
                              //   //           "No Tax",
                              //   //         ].contains(item.imageUrl))
                              //   //     ? item.imageUrl
                              //   //     : "https://cdn.watter.dk/product/no-image-available.png",
                              //       item.imageUrl,
                              //   fit: BoxFit.fitHeight,
                              //   errorListener: (value) =>
                              //       Image.asset('assets/notfound.png'),
                              //   placeholder: (context, url) =>
                              //       SizedBox.shrink(),
                              //   width: double.infinity,
                              // ),
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl.isNotEmpty
                                    ? item.imageUrl
                                    : "https://cdn.watter.dk/product/no-image-available.png",
                                fit: BoxFit.contain,
                                width: double.infinity,
                                placeholder: (context, url) =>
                                    const SizedBox.shrink(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      'assets/notfound.png',
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ),
                          ),

                          // ✅ Favorite icon
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Obx(() {
                              final isFav = productCtr.isFavorite(
                                int.parse(item.id),
                              );
                              return GestureDetector(
                                onTap: () => productCtr.toggleFavorite(
                                  int.parse(item.id),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    // 🔥 Name + Price
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth < 600 ? 14 : 16,
                                ),
                              ),
                            ),
                            Text(
                              "\$${item.price}",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: screenWidth < 600 ? 13 : 18,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
