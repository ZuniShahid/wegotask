import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../databse/collections.dart';

class GeneralController extends GetxController {
  RxInt isUploaded = 0.obs;
  RxInt CURRENT_VIDEO_INDEX = 0.obs;
  RxInt CURRENT_PAGE = 1.obs;
  RxBool showHomeRefreshLoader = false.obs;
  RxString CURRENT_USER_COUNTRY = ''.obs;
  RxString FCM_TOKEN = ''.obs;
  RxString LOGIN_TYPE = ''.obs;
  RxInt TOTAL_PRODUCTS = 0.obs;

  @override
  void onInit() {
    _setFCMToken();
    super.onInit();
  }

  Future<void> getUserCountry() async {
    var docs = await Collections.TASKS.get();
    TOTAL_PRODUCTS(docs.docs.length);
    try {
      await http.get(Uri.parse('http://ip-api.com/json')).then((value) {
        print("User Country: ${json.decode(value.body)['country'].toString()}");
        print("Total Products: ${TOTAL_PRODUCTS.value}");
        CURRENT_USER_COUNTRY(json.decode(value.body)['country'].toString());
      });
    } catch (err) {
      //handle
    }
  }

  _setFCMToken() async {
    String token = (await FirebaseMessaging.instance.getToken())!;
    FCM_TOKEN(token);
    print("FCM TOKEN : ${FCM_TOKEN.value}");
  }
}
