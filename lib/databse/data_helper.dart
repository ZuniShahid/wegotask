import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controller/general_controller.dart';
import 'collections.dart';
import '../models/user_model.dart';

class DataHelper {
  static List<DocumentSnapshot> fetchedProducts = [];
  static final state = Get.find<GeneralController>();

  static getNewDocId() {
    var newDoc = FirebaseFirestore.instance.collection('users').doc();
    return newDoc.id;
  }

  // static fetchCategories(var collection) async {
  //   var documents = await collection.get();
  //   if (documents.docs.isNotEmpty) {
  //     appCategories = RxList<CategoryModel>.from(
  //         documents.docs.map((x) => CategoryModel.fromJson(x.data())));
  //     for (int i = 0; i < appCategories.length; i++) {
  //       List<ProductModel> prods = await fetchProductsWithCondition(
  //           Collections.PRODUCTS, 'category_id', appCategories[i].id);
  //       appCategories[i].products = prods;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  // static fetchHashtags(var collection) async {
  //   var documents = await collection.get();
  //   if (documents.docs.isNotEmpty) {
  //     appHashtags = RxList<TagModel>.from(
  //         documents.docs.map((x) => TagModel.fromJson(x.data())));
  //     for (int i = 0; i < appHashtags.length; i++) {
  //       List<ProductModel> prods = await fetchProductsWithCondition(
  //           Collections.PRODUCTS, '_id', appHashtags[i].productIds,
  //           operation: 'whereIn');
  //       appHashtags[i].products = prods;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  static getFcmToken(CollectionReference collection, var userId) async {
    QuerySnapshot<Object?> querySnapshot =
        await collection.where('user', isEqualTo: userId).limit(1).get();
    var fcmToken = querySnapshot.docs.first.get('fcm_token');
    return fcmToken;
  }

  static updateFcmToken(var collection, String userId, String newFcmToken) {
    collection
        .where('user', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        collection.doc(doc.id).update({'fcm_token': newFcmToken});
      }
    });
  }

  static saveFcmToken(CollectionReference collection, var userId) async {
    var data = {'fcm_token': state.FCM_TOKEN.value, 'user': userId};
    await collection.add(data);
  }

  static fetchUserFromId(String id) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    UserModel user = UserModel.fromJson(userDoc.data()!);
    return user;
  }

  static addCollectionData(
      CollectionReference collection, String docId, var data) {
    collection.doc(docId).set(data);
  }

  static addSubCollectionData(CollectionReference collection, String docId,
      String subCollectionName, String newDocId, var data) async {
    await collection
        .doc(docId)
        .collection(subCollectionName)
        .doc(newDocId)
        .set(data);
  }

  static fetchCollectionData(var collection) async {
    var documents = await collection.get();
    return documents.docs;
  }

  static checkSubCollectionDocExistence(CollectionReference collection,
      String mainDocId, String subColName, String docId) async {
    try {
      var querySnapshot = await collection
          .doc(mainDocId)
          .collection(subColName)
          .doc(docId)
          .get();

      if (querySnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static updateQuery(
      var collection, String docId, String key, var value) async {
    await collection
        .doc(docId)
        .update({key: value})
        .then((_) => print('Success'))
        .catchError((error) {
          if (error is FirebaseException && error.code == 'not-found') {
            collection.doc(docId).set({key: value});
          } else {
            throw error;
          }
          print('updateQuery Failed: $error');
        });
  }

  static updateProfile(var collection, String docId, var data) async {
    await collection
        .doc(docId)
        .update(data)
        .then((_) => print('Success'))
        .catchError((error) {
      throw error;
    });
  }

  static updateSubCollectionData(var collection, String mainDocId,
      String subCollectionName, String docId, String key, var value) async {
    await collection
        .doc(mainDocId)
        .collection(subCollectionName)
        .doc(docId)
        .update({key: value})
        .then((_) => print('Success'))
        .catchError((error) => print('updateQuery Failed: $error'));
  }

  static deleteFromCollection(
    var collection,
    String docId,
  ) async {
    await collection
        .doc(docId)
        .delete()
        .then((_) => print('Success'))
        .catchError((error) => print('deleteFromCollection Failed: $error'));
  }

  static deleteFromSubCollection(
      var collection, String mainDocId, String subColName, String docId) async {
    await collection
        .doc(mainDocId)
        .collection(subColName)
        .doc(docId)
        .delete()
        .then((_) => print('Success'))
        .catchError((error) => print('deleteFromSubCollection Failed: $error'));
  }

  static deleteSubCollection(
      var collection, String mainDocId, String subColName) async {
    final collectionRef = collection.doc(mainDocId).collection(subColName);
    final batch = FirebaseFirestore.instance.batch();
    final querySnapshot = await collectionRef.get();
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    await batch.commit();
    print('Collection $subColName deleted successfully');
  }

  static searchFromCollection(var collection, String key, String value) async {
    var documents = await collection
        .where(key, isGreaterThanOrEqualTo: value)
        .where(key, isLessThanOrEqualTo: '$value\uf8ff')
        .get();
    return documents.docs;
  }

  static sendNotification(var map, var data, var userId) async {
    String url = "https://fcm.googleapis.com/fcm/send";
    String token = await getFcmToken(Collections.FCM_TOKENS, userId);
    var apiData = {
      "to": token,
      "notification": {"title": map['title'], "body": map['body']},
      "data": data
    };
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(apiData), headers: {
        // "Authorization": "Bearer ${AppConstants.API_KEY}",
        "Content-Type": "application/json"
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == 1) {
          return 'true';
        } else {
          return 'false';
        }
      } else {
        return "error";
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
