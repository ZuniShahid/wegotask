import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common/colors.dart';
import '../../common/custom_validators.dart';
import '../../common/input_decorations.dart';
import '../../components/account_exists_check.dart';
import '../home/home_page.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool checkboxValue = false;
  bool isLoading = false;
  bool _passwordVisible = false;
  final bool _isValidate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
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
                    'Login To You Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                doubleSpace(),
                _innerBody(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(85.w, 6.h),
                    maximumSize: Size(85.w, 6.h),
                  ),
                  onPressed: _isValidate
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            _loginButtonPressed();
                          }
                        }
                      : () {
                          Get.to(() => const HomePage());
                        },
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                singleSpace(),
                const AlreadyHaveAnAccountCheck(
                  login: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _innerBody() {
    return Column(
      children: <Widget>[
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
                color:
                    idController.text == '' ? AppColors.appGrey : Colors.black,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: idController,
                  validator: (value) => CustomValidator.email(value),
                  cursorColor: Colors.grey,
                  decoration: InputDecorations.inputDecorationAllBorder(
                    hintText: 'Email',
                  ),
                ),
              ),
            ],
          ),
        ),
        singleSpace(),
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
                color: passwordController.text == ''
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
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return "Please Enter Valid Password";
                      } else {
                        return null;
                      }
                    },
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
              )
            ],
          ),
        ),
        singleSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.hintColor,
                ),
                children: [
                  TextSpan(
                    text: 'Forgot Password ?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.hintColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(
                          () => const ForgotPassword(),
                          duration: const Duration(milliseconds: 30),
                          transition: Transition.leftToRight,
                        );
                      },
                  ),
                ],
              ),
            )
          ],
        ),
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

  void _loginButtonPressed() {
    var body = {
      'email': idController.text,
      'password': passwordController.text,
    };
    // PageTransition.fadeInNavigation(page: const LoginScreen());
  }
}
