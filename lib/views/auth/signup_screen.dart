import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';

import '../../common/colors.dart';
import '../../common/custom_dialog.dart';
import '../../common/custom_validators.dart';
import '../../common/input_decorations.dart';
import '../../components/account_exists_check.dart';
import '../../controller/general_controller.dart';
import '../../databse/auth_helper.dart';
import '../../databse/collections.dart';
import '../../databse/data_helper.dart';
import '../../global_variables.dart';
import '../main/home_page.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loader = false;
  PhoneNumber number =
      PhoneNumber(isoCode: Platform.localeName.split('_').last);

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _confirmPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final TextEditingController _phoneController = TextEditingController();

  Widget phoneNumberField() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        var countryCode = number.dialCode.toString();
        _phoneController.text = countryCode + _phoneController.text.trim();
        if (number.phoneNumber!.isNotEmpty) {
          if (_phoneController.text[0] == "0") {
            setState(() {
              _phoneController.text = "";
            });
          }
        }
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
      inputDecoration: InputDecorations.inputDecorationAllBorder(
        hintText: 'Phone Number',
      ),
      spaceBetweenSelectorAndTextField: 0,
      isEnabled: true,
      textFieldController: _phoneController,
      formatInput: true,
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: false),
      inputBorder: InputBorder.none,
      onSaved: (PhoneNumber number) {
        print('On Saved: $number');
      },
    );
  }

  registerUser() async {
    final result = await AuthHelper.signUp(Collections.USERS);
    if (result == 'true') {
      var status = await AuthHelper.login(
          Collections.USERS, userSignUp.email, userSignUp.password);
      if (status == "true") {
        DataHelper.saveFcmToken(
          Collections.FCM_TOKENS,
          userData!.id,
        );
        setState(() {
          loader = false;
        });
        Get.offAll(() => const HomePage());
      } else {
        setState(() {
          loader = false;
        });
        Get.snackbar('Error', status);
      }
    } else {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> _signupButtonPressed() async {
    setState(() {
      loader = true;
    });
    CustomDialogBox.showLoading('Sending OTP');
    userSignUp.name = _firstNameController.text;
    userSignUp.lastName = _lastNameController.text;
    userSignUp.email = _emailController.text.trim();
    userSignUp.password = _passwordController.text;
    userSignUp.contact = _phoneController.text.trim();
    userSignUp.fcmToken = Get.find<GeneralController>().FCM_TOKEN.value;
    bool uniqueUsername = await AuthHelper.checkUniqueness(
        'email', _emailController.text, Collections.USERS);
    if (uniqueUsername) {
      bool uniqueEmail = await AuthHelper.checkUniqueness(
          'name', _firstNameController.text, Collections.USERS);
      if (uniqueEmail) {
        bool isUnique = await AuthHelper.checkUniqueness(
            'contact', _phoneController.text.trim(), Collections.USERS);
        if (isUnique) {
          CustomDialogBox.hideLoading();

          // registerUser();
          Get.to(OTPScreen(
            phoneNumber: _phoneController.text.trim(),
          ));
        } else {
          setState(() {
            CustomDialogBox.hideLoading();
          });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Oops',
            desc: 'Phone number is already taken',
            dialogBackgroundColor: Colors.grey.shade800,
            btnOkOnPress: () {},
          ).show();
        }
      } else {
        setState(() {
          CustomDialogBox.hideLoading();
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Oops',
          desc: 'Email Already Exists',
          dialogBackgroundColor: Colors.grey.shade800,
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      setState(() {
        CustomDialogBox.hideLoading();
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Oops',
        desc: 'Username Already Exists',
        dialogBackgroundColor: Colors.grey.shade800,
        btnOkOnPress: () {},
      ).show();
    }

    // if (_formKey.currentState!.validate()) {
    //   // authController.userRegister(body);
    //   //   // PageTransition.fadeInNavigation(page: const LoginScreen());
    // }
  }

  Widget _singleSpace() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _doubleSpace() {
    return const SizedBox(
      height: 90,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: 70,
                  height: 80,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Center(
                child: Text(
                  'Create New Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              _singleSpace(),
              Column(
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
                        Icon(
                          Icons.person,
                          color: _firstNameController.text == ''
                              ? AppColors.appGrey
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _firstNameController,
                            validator: (value) => CustomValidator.email(value),
                            cursorColor: Colors.grey,
                            decoration:
                                InputDecorations.inputDecorationAllBorder(
                              hintText: 'First Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _singleSpace(),
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
                        Icon(
                          Icons.person,
                          color: _lastNameController.text == ''
                              ? AppColors.appGrey
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (v) {
                              setState(() {});
                            },
                            controller: _lastNameController,
                            validator: (value) => CustomValidator.email(value),
                            cursorColor: Colors.grey,
                            decoration:
                                InputDecorations.inputDecorationAllBorder(
                              hintText: 'Last Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _singleSpace(),
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
                        Icon(
                          Icons.email,
                          color: _emailController.text == ''
                              ? AppColors.appGrey
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _emailController,
                            validator: (value) => CustomValidator.email(value),
                            cursorColor: Colors.grey,
                            decoration:
                                InputDecorations.inputDecorationAllBorder(
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _singleSpace(),
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
                        Icon(
                          Icons.lock_outline_sharp,
                          color: _passwordController.text == ''
                              ? AppColors.appGrey
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              obscureText: !_passwordVisible,
                              controller: _passwordController,
                              validator: (value) =>
                                  CustomValidator.password(value),
                              cursorColor: Colors.grey,
                              decoration:
                                  InputDecorations.inputDecorationAllBorder(
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
                        )
                      ],
                    ),
                  ),
                  _singleSpace(),
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
                        Icon(
                          Icons.lock_outline_sharp,
                          color: _confirmPasswordController.text == ''
                              ? AppColors.appGrey
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            obscureText: !_confirmPasswordVisible,
                            controller: _confirmPasswordController,
                            validator: (value) =>
                                CustomValidator.confirmPassword(
                                    value, _confirmPasswordController.text),
                            cursorColor: Colors.grey,
                            decoration:
                                InputDecorations.inputDecorationAllBorder(
                              hintText: 'Confirm Password',
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
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
                        )
                      ],
                    ),
                  ),
                  _singleSpace(),
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
                        // Icon(
                        //   Icons.lock_outline_sharp,
                        //   color: _confirmPasswordController.text == ''
                        //       ? AppColors.appGrey
                        //       : Colors.black,
                        // ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Expanded(
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
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
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            initialValue: number,
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
              _doubleSpace(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(85.w, 6.h),
                  maximumSize: Size(85.w, 6.h),
                ),
                onPressed: () => _signupButtonPressed(),
                child: const Center(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              _singleSpace(),
              const AlreadyHaveAnAccountCheck(
                login: false,
              ),
              _singleSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
