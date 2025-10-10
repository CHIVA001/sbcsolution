import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/dashboad_page/product_page/product_detail.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cyspharama_app/features/dashboad_page/product_page/services/product_service.dart';
import 'package:cyspharama_app/features/dashboad_page/product_page/controllers/product_controller.dart';

import '../../../core/themes/app_style.dart';

class ProductPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(
      ProductController(service: ProductService()),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });

    return Scaffold(
      appBar: buildAppBar(title: MyText.product.tr),
      body: RefreshIndicator(
        onRefresh: () => controller.loadInitial(),
        child: Obx(() {
          if (controller.state.value == ViewState.loading &&
              controller.products.isEmpty) {
            return AnimationLimiter(
              child: GridView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 280,
                ),
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredGrid(
                      columnCount: 2,
                      position: index,
                      duration: Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 100,
                        child: FadeInAnimation(child: _buildShimmerItem()),
                      ),
                    ),
              ),
            );
          }
          if (controller.state.value == ViewState.network) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 64.0, color: AppColors.darkGrey),
                  Text(
                    'Network not Available',
                    style: textMeduim().copyWith(color: AppColors.darkGrey),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadInitial(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (controller.state.value == ViewState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_outlined,
                    size: 64.0,
                    color: AppColors.dangerColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Error Service: 500',
                    style: textMeduim().copyWith(color: AppColors.darkGrey),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadInitial(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }
          if (controller.isError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 32.0,
                    color: AppColors.dangerColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 8.0),
                  Text('Error something!', style: textdefualt()),
                  SizedBox(height: 24.0),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadInitial(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (controller.products.isEmpty) {
            return const Center(child: Text('product is Empty'));
          }

          return AnimationLimiter(
            child: GridView.builder(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              controller: _scrollController,
              padding: const EdgeInsets.all(12.0),
              itemCount:
                  controller.products.length +
                  (controller.isLoadingMore.value ? 2 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 280,
              ),
              itemBuilder: (context, index) {
                if (index >= controller.products.length) {
                  return _buildShimmerItem();
                }

                final product = controller.products[index];

                return AnimationConfiguration.staggeredGrid(
                  columnCount: 2,
                  position: index,
                  duration: Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () =>
                            Get.to(() => ProductDetailPage(product: product)),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.textLight,
                          clipBehavior: Clip.antiAlias,
                          color: AppColors.bgColorLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag:
                                    'product_hero_${product.id}_${product.hashCode}',
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: product.imageUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              product.imageUrl,
                                            ),
                                            // fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: product.imageUrl.isEmpty
                                      ? Icon(
                                          Icons.image,
                                          size: 40,
                                          color: AppColors.lightGrey,
                                        )
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        product.type,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey.withOpacity(0.5),
      highlightColor: AppColors.bgColorLight.withOpacity(0.1),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 150, color: Colors.white),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 16,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 14,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
