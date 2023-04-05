import 'package:cloud_firestore/cloud_firestore.dart';

class Collections {
  static var CATEGORIES = FirebaseFirestore.instance.collection('categories');
  static var FCM_TOKENS = FirebaseFirestore.instance.collection('fcmTokens');
  static var TASKS = FirebaseFirestore.instance.collection('tasks');
  static var USERS = FirebaseFirestore.instance.collection('users');
}
