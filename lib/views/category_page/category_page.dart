import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/views/product_detail.dart';

import '../home_page/controllers/category_controller.dart';
import '../home_page/controllers/product_controller.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryCtr = Get.find<CategoryController>();
    final productCtr = Get.find<ProductController>();

    // ✅ Detect screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final space = screenWidth > 600 ? 16.0 : 8.0;

    // ✅ Responsive grid column count
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2; // Phones
    } else if (screenWidth < 900) {
      crossAxisCount = 3; // Small tablets
    } else {
      crossAxisCount = 4; // Large tablets
    }

    return Scaffold(
      backgroundColor: AppColors.lightBgLight,
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search
            Container(
              margin: EdgeInsets.symmetric(horizontal: space),
              width: double.infinity,
              height: 40,
              child: TextFormField(
                onChanged: (val) => productCtr.search(val),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: AppColors.lightTextMuted),
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.darkTextMuted,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // 🔹 Body
            Expanded(
              child: Row(
                children: [
                  // 👉 Categories
                  Obx(() {
                    final categories = [
                      "All",
                      ...categoryCtr.categoryList.map((c) => c.name).toList(),
                    ];

                    return Container(
                      width: screenWidth > 600 ? 120 : 80,
                      color: AppColors.darkText,
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final catName = categories[index];
                          return Obx(() {
                            final isSelected =
                                productCtr.selectedCategory.value == catName;

                            return GestureDetector(
                              onTap: () => productCtr.filterByCategory(catName),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 8.0,
                                ),
                                alignment: index == 0
                                    ? Alignment.center
                                    : Alignment.centerLeft,
                                color: isSelected
                                    ? Colors.blue.shade100
                                    : Colors.transparent,
                                child: Text(
                                  catName,
                                  style: TextStyle(
                                    fontSize: screenWidth > 600 ? 14 : 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.blue
                                        : AppColors.lightText,
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    );
                  }),

                  // 👉 Products grid
                  Expanded(
                    child: Obx(() {
                      if (productCtr.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (productCtr.error.isNotEmpty) {
                        return Center(child: Text(productCtr.error.value));
                      }
                      if (productCtr.filteredProducts.isEmpty) {
                        return const Center(child: Text("No Products"));
                      }

                      return GridView.builder(
                        itemCount: productCtr.filteredProducts.length,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth > 600 ? 16 : 8.0,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: space,
                          crossAxisSpacing: space,
                          childAspectRatio: screenWidth > 600 ? 3 / 4 : 4 / 5,
                        ),
                        itemBuilder: (context, index) {
                          final product = productCtr.filteredProducts[index];
                          return GestureDetector(
                            onTap: () =>
                                Get.to(() => ProductDetail(product: product)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightBgDark.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightBgLight,
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        border: Border.all(
                                          color: AppColors.darkTextMuted,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Hero(
                                          tag: '${product.id}-$index',
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: 150,
                                              minHeight: 90,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: product.imageUrl,
                                              // height: 90,
                                              width: double.infinity,
                                              // fit: BoxFit.fitHeight,
                                              placeholder: (context, url) =>
                                                  const SizedBox.shrink(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                        'assets/notfound.png',
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: screenWidth > 600 ? 14 : 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: screenWidth > 900 ? 3 : 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
