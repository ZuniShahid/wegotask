import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common/colors.dart';
import '../../common/custom_validators.dart';
import '../../common/input_decorations.dart';
import '../../components/account_exists_check.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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

  void _signupButtonPressed() {
    Get.to(() => const OTPScreen(phoneNumber: '0315'));
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
}
