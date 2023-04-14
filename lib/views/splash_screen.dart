import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../common/colors.dart';
import '../databse/auth_helper.dart';
import '../databse/collections.dart';
import '../global_variables.dart';
import 'auth/login_screen.dart';
import 'main/home_page.dart';

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
    bool isLoggedIn = await getUserLoggedIn();
    var id = await getUserUID();
    print('ID: $id');
    if (isLoggedIn) {
      var status = await AuthHelper.fetchUser(Collections.USERS, id);
      if (status) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          Get.offAll(() => const HomePage());
        });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offAll(() => const LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Image.asset(
          "assets/icons/logo.png",
          width: 30.w,
        ),
      ),
    );
  }
}
