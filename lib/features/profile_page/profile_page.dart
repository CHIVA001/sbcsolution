import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_style.dart';
import '../../core/utils/app_image.dart';
import '../../widgets/build_app_bar.dart';
import '../../widgets/cached_image.dart';
import '../auth/controllers/auth_controller.dart';
import '../home_page/components/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final _keyState = GlobalKey<ScaffoldState>();
  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _keyState,
      appBar: buildAppBarMain(scaffoldKey: _keyState),
      // drawer
      drawer: AppDrawer(),
      body: Obx(() {
        final user = _controller.user.value;
        return ListView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            Container(
              width: size.width * 0.3,
              height: size.width * 0.3,
              margin: EdgeInsets.symmetric(vertical: 24.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: user != null
                  ? cachedImgae(imageUrl: "${user.image}")
                  : Image.asset(AppImage.defualtUser),
            ),
            Text(
              '${user?.fullName}',
              style: textBold().copyWith(
                color: AppColors.primaryColor,
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '@${user?.username}',
              style: textdefualt().copyWith(color: AppColors.darkGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),

            SizedBox(height: 12.0),
            user?.empId != '0'
                ? _textInput(icon: Icons.person, hintText: 'Employee')
                : SizedBox.shrink(),

            SizedBox(height: 16.0),
            _textInput(
              icon: Icons.phone,
              hintText: user?.phone != '' ? '${user?.phone}' : 'N/A',
            ),
            SizedBox(height: 16.0),
            _textInput(
              icon: Icons.mail,
              hintText: user?.email != null ? '${user?.email}' : 'N/A',
            ),
            SizedBox(height: 16.0),
            _textInput(
              // for gender
              icon: user?.gender == 'male' ? Icons.male : Icons.woman,
              hintText: user?.gender != null ? '${user?.gender}' : 'N/A',
            ),
            SizedBox(height: 16.0),
            _textInput(
              //comany
              icon: Icons.work,
              hintText: user?.company != null ? '${user?.company}' : 'N/A',
            ),
            SizedBox(height: 40.0),
          ],
        );
      }),
    );
  }
}

class _textInput extends StatelessWidget {
  const _textInput({required this.hintText, required this.icon});

  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.darkGrey),
          hintText: hintText,
          border: OutlineInputBorder(),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.lightGrey),
          ),
          hintStyle: textdefualt().copyWith(color: AppColors.primaryDarker),
          filled: true,
          enabled: false,
          fillColor: AppColors.bgColorLight,
        ),
      ),
    );
  }
}
