import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

UserModel userSignUp = UserModel(
    id: "newUserSignUpId",
    name: "",
    email: "",
    lastName: "",
    loginType: 'app',
    contact: "",);
UserModel? userData;

void setUserLoggedIn(bool key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLoggedIn", key);
}

Future getUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getBool("isLoggedIn") ?? false;
  return log;
}

void saveUserUID(String id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString("userId", id);
}

Future getUserUID() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String result = pref.getString("userId") ?? '';
  return result;
}
