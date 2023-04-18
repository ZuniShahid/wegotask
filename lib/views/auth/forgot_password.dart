import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../common/colors.dart';
import '../../common/input_decorations.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  final bool? fromForgotPassword;
  const ForgotPassword({Key? key, this.fromForgotPassword = false})
      : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _phoneController = TextEditingController();
  PhoneNumber numberrrr =
      PhoneNumber(isoCode: Platform.localeName.split('_').last);
  String phoneNumber = '';

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
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          var countryCode = number.dialCode.toString();
                          phoneNumber =
                              countryCode + _phoneController.text.trim();
                          if (number.phoneNumber!.isNotEmpty) {
                            if (_phoneController.text[0] == "0") {
                              setState(() {
                                _phoneController.text = "";
                              });
                            }
                          }

                          print('PHONENUMBER: $phoneNumber');
                          setState(() {});
                        },
                        onInputValidated: (bool value) {
                          print(value);
                          setState(() {});
                        },
                        selectorConfig: const SelectorConfig(
                          leadingPadding: 0,
                          trailingSpace: false,
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          setSelectorButtonAsPrefixIcon: true,
                          showFlags: true,
                        ),
                        ignoreBlank: true,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: PhoneNumber(isoCode: 'PK'),
                        inputDecoration:
                            InputDecorations.inputDecorationAllBorder(
                          hintText: 'Phone Number',
                        ),
                        spaceBetweenSelectorAndTextField: 0,
                        isEnabled: true,
                        textFieldController: _phoneController,
                        formatInput: true,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        inputBorder: InputBorder.none,
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
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
                    () => OTPScreen(
                      fromForgotPass: widget.fromForgotPassword,
                      phoneNumber: phoneNumber.trim(),
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
