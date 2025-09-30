import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/auth/auth_controller.dart';
import 'package:weone_shop/constants/app_color.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authCtr = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkText,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 64.0,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: AppColors.lightBgLight,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBg,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Please enter your username & password correctly',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightTextMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  // Username Field
                  TextFormField(
                    controller: _usernameCtr,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(RemixIcons.user_3_line),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: AppColors.darkBgDark),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  // Password Field
                  Obx(
                    () => TextFormField(
                      controller: _passwordCtr,
                      obscureText: !authCtr.showPassword.value,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(RemixIcons.lock_password_line),
                        suffixIcon: IconButton(
                          onPressed: () {
                            authCtr.showPassword.value =
                                !authCtr.showPassword.value;
                          },
                          icon: Icon(
                            authCtr.showPassword.value
                                ? RemixIcons.eye_line
                                : RemixIcons.eye_close_line,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: authCtr.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  authCtr.login(
                                    _usernameCtr.text.trim(),
                                    _passwordCtr.text.trim(),
                                  );
                                }
                              },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        child: authCtr.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.lightBgLight,
                                ),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
