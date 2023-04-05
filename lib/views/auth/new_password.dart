import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common/colors.dart';
import '../../common/custom_validators.dart';
import '../../common/input_decorations.dart';
import 'login_screen.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _cPasswordController = TextEditingController();
  bool _confirmPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Column innerBody() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.lock,
                color: AppColors.appGrey,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                    onChanged: (value) {},
                    obscureText: !_passwordVisible,
                    controller: _passwordController,
                    validator: (value) => CustomValidator.password(value),
                    cursorColor: Colors.grey,
                    decoration: InputDecorations.inputDecorationAllBorder(
                      hintText: 'Password',
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.appGrey,
                          size: 20,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.lock,
                color: AppColors.appGrey,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  onChanged: (value) {},
                  obscureText: !_confirmPasswordVisible,
                  controller: _cPasswordController,
                  validator: (value) => CustomValidator.confirmPassword(
                      value, _cPasswordController.text),
                  cursorColor: Colors.grey,
                  decoration: InputDecorations.inputDecorationAllBorder(
                    hintText: 'Confirm Password',
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.appGrey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        singleSpace(),
        singleSpace(),
        singleSpace(),
        doubleSpace(),
      ],
    );
  }

  Widget doubleSpace() {
    return const SizedBox(
      height: 40,
    );
  }

  Widget singleSpace() {
    return const SizedBox(
      height: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              doubleSpace(),
              Center(
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: 70,
                  height: 80,
                ),
              ),
              doubleSpace(),
              const Center(
                child: Text(
                  'Create new password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              doubleSpace(),
              innerBody(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(85.w, 6.h),
                  maximumSize: Size(85.w, 6.h),
                ),
                onPressed: () {
                  Get.to(
                    () => const LoginScreen(),
                    duration: const Duration(milliseconds: 30),
                    transition: Transition.leftToRight,
                  );
                },
                child: const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              singleSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
