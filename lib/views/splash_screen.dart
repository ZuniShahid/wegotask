import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../common/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    _navigate();
    super.initState();
  }

  _navigate() async {
    // bool isLoggedIn = await AuthPrefrence().getUserLoggedIn();

    // if (isLoggedIn) {
    //   Future.delayed(const Duration(milliseconds: 2000), () {
    //     Get.offAll(() => const HomePage());
    //   });
    // } else {
    //   Future.delayed(const Duration(milliseconds: 2000), () {
    //     Get.offAll(() => const LoginScreen());
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Image.asset(
          'assets/images/LMS_heading.png',
          width: 30.w,
        ),
      ),
    );
  }
}
