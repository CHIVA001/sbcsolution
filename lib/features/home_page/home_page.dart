import 'package:cyspharama_app/core/utils/app_image.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:cyspharama_app/features/auth/controllers/nav_bar_controller.dart';
import 'package:cyspharama_app/features/home_page/components/app_drawer.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/home_page/components/scan_qr_page.dart';
import 'package:cyspharama_app/features/home_page/components/tap_scan_attendance.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import '../../core/themes/app_style.dart';
import '../../widgets/cached_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.find<AuthController>();
  final _navCtr = Get.find<NavBarController>();

  final _keyState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller.refreshUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _keyState,
      appBar: buildAppBarMain(scaffoldKey: _keyState),
      // drawer
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => _controller.getProfile(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _buildMainProfile()),
              SliverToBoxAdapter(child: _buildDashBoard(size: size.width)),
              SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(height: 50),
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingButton(),
    );
  }

  Widget _buildMainProfile() {
    return GestureDetector(
      onTap: () => _navCtr.currentIndex = 2,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        padding: EdgeInsets.all(12.0),
        width: double.infinity,
        height: 80.0,
        decoration: BoxDecoration(
          color: AppColors.bgColorLight,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: AppColors.lightGrey,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Obx(() {
          final user = _controller.user.value;
          final now = DateTime.now();
          final formatDate = DateFormat('dd/MM/yyyy').format(now);
          return Row(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: user != null
                    ? cachedImgae(imageUrl: "${user.image}")
                    : Image.asset(AppImage.defualtUser),
              ),

              SizedBox(width: 16.0),
              Text(user != null ? user.fullName : "", style: textdefualt()),

              Spacer(),
              Text(
                formatDate,
                style: textMeduim().copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDashBoard({required double size}) {
    return Container(
      constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: 800),
      child: AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dashboadItem.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
          ),
          itemBuilder: (context, index) {
            final item = dashboadItem[index];
            return AnimationConfiguration.staggeredGrid(
              columnCount: 3,
              position: index,
              duration: Duration(milliseconds: 800),
              child: SlideAnimation(
                verticalOffset: 100,
                child: FadeInAnimation(
                  child: Material(
                    color: AppColors.bgColorLight,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      focusColor: AppColors.lightGrey,
                      splashColor: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Get.toNamed(item['page']()),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  item['icon'],
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                // height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '${item['title']}'.tr,
                                  style: textMeduim().copyWith(
                                    fontSize: size > 600 ? 22 : 14,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Obx(() {
      final user = _controller.user.value;
      IconData icon = Icons.fingerprint;

      if (user != null) {
        icon = user.isRemoteAllow == '0'
            ? Icons.qr_code_scanner
            : Icons.fingerprint;
      }

      return SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (user != null && user.isRemoteAllow == "0") {
              Get.to(() => ScanQrPage(), transition: Transition.downToUp);
            } else {
              Get.to(
                () => TapScanAttendance(),
                transition: Transition.downToUp,
              );
              //
            }
          },
          child: Icon(icon, color: AppColors.backgroundColor),
        ),
      );
    });
  }
}
