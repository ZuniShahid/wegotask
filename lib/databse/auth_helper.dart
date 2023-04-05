import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../global_variables.dart';
import 'collections.dart';
import '../models/user_model.dart';

import '../controller/general_controller.dart';
import 'data_helper.dart';

class AuthHelper {
  static final state = Get.find<GeneralController>();

  static signUp(var collection) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userSignUp.email, password: userSignUp.password);
      User? user = result.user;
      await collection.doc(user!.uid).set({
        "_id": user.uid,
        "name": userSignUp.name,
        "email": userSignUp.email.trim(),
        "last_name": userSignUp.lastName,
        "contact": userSignUp.contact.trim(),
      });
      DataHelper.saveFcmToken(Collections.FCM_TOKENS, user.uid);
      return "true";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  static login(var collection, String email, String pass) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      var document = await collection.doc(userCredential.user!.uid).get();
      if (document.exists) {
        userData = UserModel.fromJson(document.data()!);
        DataHelper.updateFcmToken(Collections.FCM_TOKENS,
            userCredential.user!.uid, state.FCM_TOKEN.value);
        setUserLoggedIn(true);
        saveUserUID(userCredential.user!.uid);
        return "true";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found";
      } else if (e.code == 'wrong-password') {
        return "Invalid Password";
      }
    }
  }

  static fetchUser(var collection, String docId) async {
    var document = await collection.doc(docId).get();
    print("fetchUser");
    print(docId);
    if (document.exists) {
      userData = UserModel.fromJson(document.data()!);
      DataHelper.updateFcmToken(
          Collections.FCM_TOKENS, userData!.id, state.FCM_TOKEN.value);
      return true;
    }
    return false;
  }

  static checkUniqueness(String key, String value, var collection) async {
    QuerySnapshot document =
        await collection.where(key, isEqualTo: value).limit(1).get();
    if (document.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static getUserFromContact(String contact) async {
    // var document = await Collections.USERS.findOne({'contact': contact});
    // print(document['_id']);
    // return document['_id'];
  }
}
