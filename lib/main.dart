import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'getx/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: "Devish",
      initialRoute: "/homeScreen",
      getPages: [
        GetPage(name: "/homeScreen", page: () => HomeScreen()),
      ],
    );
  }
}
