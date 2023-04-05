// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:valuefy/controller/general_controller.dart';
// import 'package:valuefy/databse/auth_helper.dart';
// import 'package:valuefy/databse/collections.dart';

// import '../screens/Home/bottom_navigation.dart';
// import '../utils/constants.dart';
// import '../utils/global_variables.dart';

// class GoogleAuthenticateProvider extends ChangeNotifier {
//   final state = Get.find<GeneralController>();
//   GoogleSignInAccount? _currentUser;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: <String>[
//       'email',
//     ],
//   );

//   Future<void> signIn(bool fromLogin) async {
//     signOut();
//     try {
//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser != null) {
//         _currentUser = googleUser;
//         final googleAuth = await googleUser.authentication;
//         GoogleAuthProvider.credential(
//             accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
//         print('google creds');
//         print(_currentUser!.email.toString());
//         bool result = await AuthHelper.checkUniqueness(
//             'email', _currentUser!.email.toString(), Collections.USERS);
//         if (result) {
//           state.LOGIN_TYPE("google");
//           userSignUp.email = _currentUser!.email.toString();
//           userSignUp.password = _currentUser!.id.toString();
//           userSignUp.image = _currentUser!.photoUrl.toString();
//           userSignUp.loginType = 'google';
//           registerUser();
//         }
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error is $e');
//     }
//   }

//   Future<void> signOut() async {
//     print('I am google signing out');
//     _googleSignIn.disconnect();
//     notifyListeners();
//   }
// }

// registerUser() async {
//   final result = await AuthHelper.signUp(Collections.USERS);
//   if (result == 'true') {
//     var status = await AuthHelper.login(
//         Collections.USERS, userSignUp.email, userSignUp.password);
//     if (status == true) {
//       pageNavigationOffAll(const BottomNavigationScreen());
//     }
//   } else {}
// }

// // class FBAuthenticateProvider extends ChangeNotifier {
// //   Future<void> signInFB(BuildContext context, bool fromLogin) async {
// //     try {
// //       final LoginResult result =
// //           await FacebookAuth.i.login(permissions: ["email"]);
// //
// //       print("checkFB");
// //       print(result);
// //
// //       if (result.status == LoginStatus.success) {
// //         print("hello");
// //         final data = await FacebookAuth.i.getUserData();
// //         // userSignUp.email = _currentUser!.email.toString();
// //         // userSignUp.password = _currentUser!.id.toString();
// //         // userSignUp.image = _currentUser!.photoUrl.toString();
// //         userSignUp.loginType = 'facebook';
// //         print('hello i am data of fb');
// //         print(data);
// //         print(data['email']);
// //         String email = '${'f' + data['id']}@facebook.com';
// //         print(email);
// //         // registerUser();
// //         notifyListeners();
// //       }
// //     } catch (e) {
// //       print('Error is $e');
// //     }
// //   }
// //
// //   Future<void> signOutFB() async {
// //     await FacebookAuth.i.logOut();
// //   }
// // }
