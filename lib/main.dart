import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/main_activity.dart';

void main() {
  runApp(const HARRecorderApp());
}

class HARRecorderApp extends StatelessWidget {
  const HARRecorderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainActivity(),
    );
  }
}
