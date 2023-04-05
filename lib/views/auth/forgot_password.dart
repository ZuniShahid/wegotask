import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common/colors.dart';
import '../../common/custom_validators.dart';
import '../../common/input_decorations.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _phoneNumberController = TextEditingController();

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
        padding: const EdgeInsets.all(15.0),
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
                  'Enter Your Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              doubleSpace(),
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
                      Icons.phone,
                      color: AppColors.appGrey,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneNumberController,
                        validator: (value) => CustomValidator.email(value),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorColor: Colors.grey,
                        decoration: InputDecorations.inputDecorationAllBorder(
                          hintText: 'Enter Your Email Address',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 130,
              ),
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
                    () => const OTPScreen(
                      phoneNumber: '0300******90',
                    ),
                    duration: const Duration(milliseconds: 30),
                    transition: Transition.leftToRight,
                  );
                },
                child: const Center(
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
