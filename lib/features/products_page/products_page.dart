import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../../core/localization/my_text.dart';
import '../../core/themes/app_colors.dart';
import '../../widgets/build_app_bar.dart';
import '../../widgets/build_shimer_page.dart';
import 'cart/cart_page.dart';
import 'controllers/cart_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/product_controller.dart';
import 'scan_product.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final _controller = Get.put(ProductsController());
  final _categoryCtr = Get.put(CategoryController());
  final _cartCtr = Get.find<CartController>();

  filterBottom() {
    Get.bottomSheet(
      backgroundColor: AppColors.bgColorLight,
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        constraints: BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(RemixIcons.equalizer_2_line),
              title: Text('Filter Options', style: textBold()),
              trailing: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.lightGrey,
                ),
                onPressed: () => Get.back(),
                icon: Icon(RemixIcons.close_line, size: 26),
              ),
            ),
            const Divider(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('View: ', style: textBold()),
                        IconButton(
                          onPressed: () {
                            _controller.toggleViewMode(ViewMode.grid);
                            Get.back();
                          },
                          style: IconButton.styleFrom(
                            backgroundColor:
                                _controller.viewMode.value == ViewMode.grid
                                ? AppColors.primaryColor
                                : Colors.transparent,
                          ),
                          icon: Icon(
                            Icons.grid_view,
                            color: _controller.viewMode.value == ViewMode.grid
                                ? AppColors.lightGrey
                                : AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        IconButton(
                          onPressed: () {
                            _controller.toggleViewMode(ViewMode.list);
                            Get.back();
                          },
                          style: IconButton.styleFrom(
                            backgroundColor:
                                _controller.viewMode.value == ViewMode.list
                                ? AppColors.primaryColor
                                : Colors.transparent,
                          ),
                          icon: Icon(
                            Icons.view_list,
                            color: _controller.viewMode.value == ViewMode.list
                                ? AppColors.textLight
                                : AppColors.textPrimary,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Category', style: textBold()),
                    ),

                    //  Reactive categories
                    Obx(() {
                      final categorys = _categoryCtr.categories;
                      final selectedId = _controller.selectedCategoryId.value;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(
                              'All',
                              style: textdefualt().copyWith(
                                color: selectedId == null
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: selectedId == null,
                            selectedColor: AppColors.primaryColor,
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: selectedId == null ? 4 : 0,
                            onSelected: (_) =>
                                _controller.filterByCategory(null),
                          ),
                          ...categorys.map((category) {
                            final bool isSelected = selectedId == category.id;
                            return ChoiceChip(
                              label: Text(
                                category.name,
                                style: textdefualt().copyWith(
                                  fontSize: 14.0,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primaryColor,
                              backgroundColor: AppColors.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: isSelected ? 4 : 0,
                              pressElevation: 2,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade400,
                                width: 1,
                              ),
                              onSelected: (_) =>
                                  _controller.filterByCategory(category.id),
                            );
                          }),
                        ],
                      );
                    }),

                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textPrimary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: Get.back,
                      child: Text('Apply Filters'),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: MyText.product.tr,
        action: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => Get.to(() => CartPage()),
            icon: Obx(
              () => Badge(
                label: Text(_cartCtr.cartItems.length.toString()),
                offset: const Offset(5, -8),
                child: Icon(
                  Icons.shopping_cart,
                  size: 28.0,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return BuildShimerPage();
              }

              final products = _controller.filteredProducts;

              if (products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return _controller.viewMode.value == ViewMode.grid
                  ? _buildGrid(products)
                  : _buildList(products);
            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => ScanProduct()),
        child: Icon(RemixIcons.qr_scan_2_line),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                filled: true,
                fillColor: AppColors.bgColorLight,
              ),

              onChanged: (value) {
                final query = value.toLowerCase();
                _controller.filteredProducts.assignAll(
                  _controller.products
                      .where((p) => p.name.toLowerCase().contains(query))
                      .toList(),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: AppColors.lightGrey),
              ),
            ),
            onPressed: filterBottom,
            icon: Icon(
              RemixIcons.equalizer_2_line,
              size: 28,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List products) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        final p = products[index];
        return GestureDetector(
          // onTap: () => Get.to(() => ProductDetail(product: p)),
          onTap: () => Get.toNamed('${AppRoutes.product}/${p.id}'),
          child: _buildGrideView(
            id: p.id,
            imageUrl: p.imageUrl,
            name: p.name,
            price: p.price,
          ),
        );
      },
    );
  }

  Widget _buildList(List products) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),

          color: AppColors.backgroundColor,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            // onTap: () => Get.to(() => ProductDetail(product: p)),
            onTap: () => Get.toNamed('${AppRoutes.product}/${p.id}'),
            minTileHeight: 100,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: p.imageUrl,
                width: 80,
                fit: BoxFit.cover,
                errorListener: (value) => Icon(Icons.image),
              ),
            ),
            title: Text(
              p.name,
              style: textdefualt(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '\$${p.price}',
              style: textBold().copyWith(color: AppColors.primaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrideView({
    required String id,
    required String imageUrl,
    required String name,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textdefualt(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$$price',
                  style: textBold().copyWith(color: AppColors.primaryColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
