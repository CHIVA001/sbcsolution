import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                right: -200,
                bottom: -100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Container(
                    width: 400,
                    height: 400,
                    color: Colors.amberAccent,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: -100,
                left: -200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Container(
                    width: 400,
                    height: 400,
                    color: Colors.blueAccent,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * .6,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Username + Password fields
                        Obx(
                          () => _controller.isLoading.value
                              ? CircularProgressIndicator()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 500,
                                      ),
                                      child: TextField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 500,
                                      ),

                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    ElevatedButton(
                                      onPressed: () {
                                        _controller.login(
                                          _usernameController.text,
                                          _passwordController.text,
                                        );
                                      },
                                      child: Text("Login"),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
