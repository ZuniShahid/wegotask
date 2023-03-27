import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefrence {
  void setUserLoggedIn(bool key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLoggedIn", key);
  }

  Future getUserLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var log = pref.getBool("isLoggedIn") ?? false;
    return log;
  }

  void saveUserDataToken({@required token}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", token);
  }

  Future getUserDataToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("token") ?? '';
    return result;
  }

  void saveUserData({@required token}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userData", token);
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("userData") ?? '';
    return result;
  }
}
