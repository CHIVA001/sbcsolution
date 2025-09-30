import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/constants/app_url.dart';

import 'views/home_page/controllers/brand_controler.dart';
import 'views/nav_bar/nav_bar_controller.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brandCtr = Get.find<BrandController>();
    final navbarCtr = Get.find<NavBarController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Brand',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          navbarCtr.changeTab(1);
          Get.back();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
        ),
        icon: Icon(
          RemixIcons.shopping_bag_3_line,
          color: AppColors.lightBgLight,
          size: 24.0,
        ),
        label: Text(
          'Go Shopping',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: AppColors.lightBgLight,
          ),
        ),
      ),
      body: Obx(() {
        final item = brandCtr.brandList;
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          children: [
            Text(
              'Shop by Brand',
              style: TextStyle(
                color: AppColors.darkBg,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Discover products form your favorite\nbrand',
              style: TextStyle(fontSize: 15.0, color: AppColors.lightTextMuted),
            ),
            //
            SizedBox(height: 24.0),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: item.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 600 ? 3 : 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemBuilder: (context, index) {
                final data = item[index];
                return Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.darkTextMuted),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadiusGeometry.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: '${AppUrl.image}/${data.image}',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              RemixIcons.store_2_fill,
                              size: size.width * 0.15,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBg,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          //
        );
      }),
    );
  }
}
