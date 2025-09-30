import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/brand_page.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/constants/app_url.dart';
import 'package:weone_shop/views/category_page/see_all_category.dart';
import 'package:weone_shop/views/home_page/controllers/brand_controler.dart';
import 'package:weone_shop/views/home_page/controllers/category_controller.dart';
import 'package:weone_shop/views/home_page/controllers/product_controller.dart';
import 'package:weone_shop/views/home_page/controllers/slider_controller.dart';
import 'package:weone_shop/views/nav_bar/nav_bar_controller.dart';

import '../../widgets/build_app_bar.dart';
import '../../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sliderCtr = Get.find<SliderController>();
  final brandCtr = Get.find<BrandController>();
  final categoryCtr = Get.find<CategoryController>();
  final productCtr = Get.find<ProductController>();
  final navBarCtr = Get.find<NavBarController>();

  @override
  void initState() {
    super.initState();
    sliderCtr.fechSlider();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),

      drawer: AppDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),

            /// Carousel Slider
            Obx(() {
              final slides = sliderCtr.sliderList
                  .where(
                    (slide) => slide.image != null && slide.image!.isNotEmpty,
                  )
                  .toList();

              if (slides.isEmpty) {
                return SizedBox(
                  height: size.width > 600 ? 300 : 200,
                  child: Center(child: Text('No slides available')),
                );
              }

              return CarouselSlider.builder(
                itemCount: slides.length,
                itemBuilder: (context, index, realIndex) {
                  final slide = slides[index];
                  return _buildSlideItem(slide.image!);
                },
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2,
                  height: size.width > 600 ? 300 : 200,
                  initialPage: 0,
                ),
              );
            }),

            /// Section Header
            _buildTextRow(
              'Brand',
              'See All',
              () =>
                  Get.to(() => BrandPage(), transition: Transition.rightToLeft),
            ),

            _buildListBrand(),

            _buildTextRow(
              'Categories',
              'See All',
              () => Get.to(
                () => SeeAllCategory(),
                transition: Transition.rightToLeft,
              ),
            ),

            _buildListCategory(),
            SizedBox(height: 16.0),

            /// Products Section
            _buildTextRow('Products', 'See All', () => navBarCtr.changeTab(1)),

            Obx(() {
              final products = productCtr.products;
              if (products.isEmpty) {
                return SizedBox(
                  height: 250,
                  child: Center(
                    child: Text(
                      "Go Shopping 🛒",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              final lastProducts = products.length <= 10
                  ? products
                  : products.sublist(products.length - 10);
              final showSeeMore = products.length > 10;

              return SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lastProducts.length + (showSeeMore ? 1 : 0),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    // "See More" button
                    if (showSeeMore && index == lastProducts.length) {
                      return GestureDetector(
                        onTap: () {
                          navBarCtr.changeTab(1);
                          Get.back();
                        },

                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                            // border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Center(
                            child: Text(
                              "See More",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final product = lastProducts[index];
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey.shade200),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/notfound.png'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),

            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String text1, String text2, void Function()? onTap2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Text(
            text1,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          InkWell(
            onTap: onTap2,
            child: Text(
              text2,
              style: const TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListBrand() {
    return Obx(() {
      if (brandCtr.brandList.isEmpty) {
        return const SizedBox(
          height: 150,
          child: Center(child: Text('No brands available')),
        );
      }

      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: brandCtr.brandList.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, index) {
            final brand = brandCtr.brandList[index];
            final imageUrl = brand.image;

            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.lightBgLight,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: '${AppUrl.image}/$imageUrl',
                      height: 100.0,
                      width: 100,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        RemixIcons.store_2_fill,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        brand.name,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildListCategory() {
    return Obx(() {
      if (categoryCtr.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (categoryCtr.categoryList.isEmpty) {
        return const SizedBox(
          height: 150,
          child: Center(child: Text('No categories found')),
        );
      }

      final category = categoryCtr.categoryList;

      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: category.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, index) {
            final item = category[index];
            final imageUrl = item.image;

            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.lightBgLight,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: '${AppUrl.image}/$imageUrl',
                      height: 100.0,
                      width: 100,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.name!,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildSlideItem(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CachedNetworkImage(
          imageUrl: '${AppUrl.image}$imageUrl',
          fit: BoxFit.cover,
          width: double.infinity,
          errorWidget: (context, url, error) => const SizedBox(),
          placeholder: (context, url) => Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
