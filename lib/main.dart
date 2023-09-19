import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/view/home/orderPage.dart';

import 'model/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderPage(),
    );
  }
}
