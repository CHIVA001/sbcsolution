import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/constants/app_color.dart';

import '../../widgets/build_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../home_page/controllers/product_controller.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtr = Get.find<ProductController>();

    return Scaffold(
      appBar: buildAppBar(),
      drawer: AppDrawer(),
      body: Obx(() {
        final favoriteProducts = productCtr.products
            .where((p) => productCtr.isFavorite(int.parse(p.id)))
            .toList();

        if (favoriteProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(RemixIcons.heart_3_line, size: 64.0, color: Colors.grey),
                Text(
                  "No favorites",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Favorite',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBg,
                ),
              ),
              SizedBox(height: 8.0),
              favoriteProducts.length > 1
                  ? Text(
                      '${favoriteProducts.length} items',
                      style: TextStyle(fontSize: 16.0, color: AppColors.darkBg),
                    )
                  : Text(
                      '${favoriteProducts.length} item',
                      style: TextStyle(fontSize: 16.0, color: AppColors.darkBg),
                    ),
              Divider(color: AppColors.darkBg),
              SizedBox(height: 8.0),
              Expanded(
                child: ListView.separated(
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final item = favoriteProducts[index];
                    final productId = int.parse(item.id);
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.lightBgLight,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: CachedNetworkImage(
                                    imageUrl: item.imageUrl,
                                    width: 100,
                                    height: double.infinity,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        right: 24.0,
                                      ),
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: Text(
                                        '\$ ${item.price}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightBg,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    productCtr.toggleFavorite(productId),
                                child: Icon(
                                  RemixIcons.delete_bin_6_line,
                                  color: Colors.red,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
