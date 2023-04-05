import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:wegotask/views/auth/new_password.dart';

import '../../common/colors.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String currentText = "";
  String error = "";
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamController<ErrorAnimationType>? errorController;

  final formKey = GlobalKey<FormState>();
  bool hasError = false;
  bool loader = false;
  bool resendLoader = false;
  TextEditingController textEditingController = TextEditingController();

  int _counter = 60;
  Timer? _timer;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    super.initState();
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        _timer!.cancel();
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  sendOTP() {
    // _auth.verifyPhoneNumber(
    //     phoneNumber: widget.phoneNumber,
    //     timeout: const Duration(seconds: 60),
    //     verificationCompleted: (AuthCredential authCredential) {
    //       print("verificationCompleted");
    //       print(authCredential);
    //     },
    //     verificationFailed: (authException) {
    //       print("verificationFailed");
    //       print(authException.message);
    //       Get.snackbar("Error", authException.message!);
    //       setState(() {
    //         _counter = 60;
    //         resendLoader = false;
    //       });
    //       startTimer();
    //     },
    //     codeSent: (String verificationId, int? token) {
    //       print("code sent");
    //       Get.snackbar("Code Sent", "");
    //       setState(() {
    //         _counter = 60;
    //         resendLoader = false;
    //       });
    //       startTimer();
    //     },
    //     codeAutoRetrievalTimeout: (String verificationId) {
    //       print("Timout");
    //       print(verificationId);
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/otp_screen.png',
                  width: 183,
                  height: 191,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'OTP Code Verification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                    text: "code has been send to ",
                    children: [
                      TextSpan(
                          text: widget.phoneNumber,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                    style: const TextStyle(color: Colors.black, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: SizedBox(
                  width: 70.w,
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    length: 4,
                    obscureText: false,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      return null;
                    },
                    pinTheme: PinTheme(
                      selectedColor: AppColors.primary,
                      selectedFillColor: const Color(0xFFFFF0E5),
                      activeColor: Colors.transparent,
                      activeFillColor: Colors.transparent,
                      shape: PinCodeFieldShape.box,
                      inactiveColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      fieldHeight: 55.w / 4,
                      fieldWidth: 55.w / 4,
                    ),
                    cursorColor: Colors.white,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Color(0xFFEDEDED),
                        // blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {},
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                        hasError = false;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? error : "",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              _counter != 0
                  ? const Text(
                      "Code Expired",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    )
                  : RichText(
                      text: TextSpan(
                          text: "Resend Code in ",
                          children: [
                            TextSpan(
                                text: '${_counter}sec',
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15)),
                      textAlign: TextAlign.center,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code?",
                    style: TextStyle(fontSize: 16),
                  ),
                  resendLoader
                      ? const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: CircularProgressIndicator.adaptive())
                      : TextButton(
                          onPressed: () async {
                            if (_counter == 0) {
                              setState(() {
                                resendLoader = true;
                              });
                              print("sending again");
                              sendOTP();
                            }
                          },
                          child: const Text(
                            "Resend again",
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 17),
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 14,
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
                  Get.to(() => const NewPassword(), duration: const Duration(milliseconds: 30),
                          transition: Transition.leftToRight,);
                  //       formKey.currentState!.validate();
                  // if (currentText.length != 6) {
                  //   errorController!.add(ErrorAnimationType.shake);
                  //   setState(() {
                  //     hasError = true;
                  //     error = " Invalid OTP";
                  //   });
                  // } else {
                  //   setState(
                  //     () {
                  //       loader = true;
                  //       hasError = false;
                  //     },
                  //   );
                  //   var credential = PhoneAuthProvider.credential(
                  //       verificationId: widget.verificationId,
                  //       smsCode: currentText);
                  //   print("credential");
                  //   print(credential);
                  //   try {
                  //     var userCred = await _auth
                  //         .signInWithCredential(PhoneAuthProvider.credential(
                  //       verificationId: widget.verificationId,
                  //       smsCode: currentText,
                  //     ));
                  //     print("userCred");
                  //     print(userCred.additionalUserInfo!.isNewUser);
                  //     print('OTP Verified');
                  //   } catch (e) {
                  //     if (e.toString().contains('invalid')) {
                  //       error = "Invalid code";
                  //     } else if (e.toString().contains('expired')) {
                  //       error = "Code is expired";
                  //     }
                  //     Get.snackbar("Error", error);
                  //   }
                  //   setState(() {
                  //     loader = false;
                  //   });
                  //   if (error == "") {
                  //     if (widget.fromForgotPass) {
                  //       pageNavigationTo(PasswordsScreen(
                  //         fromForgotPass: true,
                  //         contact: widget.phoneNumber,
                  //       ));
                  //     } else {
                  //       pageNavigationOff(UploadImage());
                  //     }
                  //   }
                  // }
                },
                child: loader == true
                    ? const CircularProgressIndicator.adaptive()
                    : const Text("Verify",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
