// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/authController.dart';
import '../../view/home/orderPage.dart';

import 'package:hama/model/login.dart';

Color dark = Colors.black;
Color blue = Colors.blue;
Color grey = const Color.fromARGB(255, 61, 59, 59);
Color white = Colors.white;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authController = Get.put(AuthController());
  bool _isPasswordVisible = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Menghitung nilai variabel double berdasarkan lebar layar
    double doble = screenWidth * 0.2;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RichText(
                  text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Hama',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30.0,
                        color: dark),
                  ),
                  TextSpan(
                    text: 'App',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: dark,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              )),
            ),
            const SizedBox(height: 25),
            Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 20.0, color: dark, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: _isPasswordVisible ? blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: doble),
            InkWell(
              onTap: () async {
                final isSuccess = await authController.login(UserLogin(
                  email: _emailController.text,
                  password: _passwordController.text,
                ));

                if (isSuccess) {
                  // Login berhasil, navigasi ke halaman OrderPage
                  Get.off(OrderPage());
                } else {
                  // Login gagal, tampilkan pesan kesalahan
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Login gagal. Periksa kembali kata sandi Anda.'),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: blue,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double lebar;

  const AddButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.lebar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * lebar,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
