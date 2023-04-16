import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../common/custom_toast.dart';
import '../controller/general_controller.dart';
import '../global_variables.dart';
import '../models/task_history_model.dart';
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

  static fetchTask(String id) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('post').doc(id).get();
    UserModel user = UserModel.fromJson(userDoc.data()!);
    return user;
  }

  static addCollectionData(
      CollectionReference collection, String docId, var data) {
    print('dasd');
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

  static dynamic updateQuery(
      var collection, String docId, String key, var value) async {
    await collection.doc(docId).update({key: value}).then((_) {
      print('Success');
    }).catchError((error) {
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

  static addInTask(var collection, String key, String value) async {
    var documents =
        await collection.where(key, isEqualTo: value).limit(1).get();

    if (documents.docs.isNotEmpty) {
      TaskModel task = TaskModel.fromJson(documents.docs[0].data()!);
      if (task.totalUsers == task.activeUsers) {
        CustomToast.errorToast(message: 'Task User Limit is Full');
        return 0;
      }
      if (task.creatorId == userData!.id) {
        CustomToast.errorToast(message: 'You are the Creator of this Task.');
        return 0;
      }
      for (int i = 0; i < task.fcmTokenList!.length; i++) {
        var taskId = task.fcmTokenList![i];
        if (taskId.toString() == state.FCM_TOKEN.toString()) {
          CustomToast.errorToast(message: 'You are already added');
          return 0;
        }
      }
      for (int i = 0; i < task.usersList!.length; i++) {
        var taskId = task.usersList![i];
        if (taskId.toString() == userData!.id.toString()) {
          CustomToast.errorToast(message: 'You are already added');
          return 0;
        }
      }
      updateQuery(Collections.TASKS, task.id.toString(), 'activeUser',
          task.activeUsers! + 1);
      var activeUser = {
        '_uid': userData!.id,
        'task_status': false,
      };
      collection.doc(task.id).set({
        'active_user_task_status': FieldValue.arrayUnion([activeUser])
      }, SetOptions(merge: true));
      collection.doc(task.id).set({
        'users_list': FieldValue.arrayUnion([userData!.id])
      }, SetOptions(merge: true));
      collection.doc(task.id).set({
        'fcm_token_list': FieldValue.arrayUnion([state.FCM_TOKEN.toString()])
      }, SetOptions(merge: true));
      CustomToast.errorToast(message: 'You are added in Task');
      var map = {
        "title": 'New User',
        "body": 'You are added in Task',
      };
      var msg = {
        'action_type': 'new_user',
        'data': userData!.toJson(),
        'sound': FIREBASE_SOUND_NAME
      };

      await sendNotification(map, msg, task.creatorId);
      return 1;
    } else {
      CustomToast.errorToast(message: 'Task not found');
      return 0;
    }
  }

  static searchTask(var collection, String key, String value) async {
    var documents =
        await collection.where(key, isEqualTo: value).limit(1).get();
    TaskModel taskModel = TaskModel();
    if (documents.docs.isNotEmpty) {
      taskModel = TaskModel.fromJson(documents.docs[0].data());
      return taskModel;
    } else {
      CustomToast.errorToast(message: 'Task not found');
      return 0;
    }
  }

  static Future<void> updateArrayElement(String documentId) async {
    try {
      // Step 1: Get Firestore instance and reference to 'tasks' collection
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var tasksCollection = firestore.collection('tasks');

      // Step 2: Get the document containing the array
      var docSnapshot = await tasksCollection.doc(documentId).get();
      if (docSnapshot.exists) {
        // Step 3: Get the array field from the document
        List<dynamic> arrayField =
            docSnapshot.data()!['active_user_task_status'];

        // Step 4: Loop through the array to find the index of the element to update
        for (int i = 0; i < arrayField.length; i++) {
          Map<String, dynamic> element =
              Map<String, dynamic>.from(arrayField[i]);
          if (element['_uid'] == userData!.id) {
            // Step 5: Update the status of the element
            element['task_status'] = true;
          }
          arrayField[i] = element;
        }

        // Step 6: Update the array field in the document
        await tasksCollection.doc(documentId).update({
          'active_user_task_status': [arrayField],
        });

        print('Array element updated successfully');
      } else {
        throw Exception('Document does not exist');
      }
    } catch (error) {
      print('Error updating array element: $error');
    }
  }

  static updateMapList(String documentId) async {
    final data = ActiveUserTaskStatus(
      notes: [
        {
          '_uid': userData!.id,
          'task_status': true,
        },
      ],
    );
    FirebaseFirestore.instance.doc('notes').set(
      {
        'active_user_task_status': FieldValue.arrayUnion([data.notes![0]]),
      },
      SetOptions(merge: true),
    );
    // var docRef = FirebaseFirestore.instance.collection('tasks').doc(documentId);

    // docRef.get().then((docSnapshot) async {
    //   if (docSnapshot.exists) {
    //     List<dynamic> myList = docSnapshot.get('active_user_task_status');
    //     await docRef.update({
    //       'active_user_task_status': FieldValue.delete(),
    //     });

    //     for (int i = 0; i < myList.length; i++) {
    //       Map<String, dynamic> map = myList[i];
    //       if (map['_uid'] == userData!.id) {
    //         map['task_status'] = true;
    //         break;
    //       }
    //     }

    //     docRef.update({'active_user_task_status': myList}).then((_) {
    //       print('List updated successfully');
    //     });
    //   } else {
    //     print('Document does not exist');
    //   }
    // }).catchError((error) {
    //   print('Error updating list: $error');
    // });
  }

  static fetchTasksFromCollection(
      var collection, String key, String value) async {
    var documents = await collection.where(key, arrayContains: value).get();
    List<TaskModel> tasks = [];

    for (var doc in documents.docs) {
      var data = doc.data();
      tasks.add(TaskModel.fromJson(data));
    }
    print('USERDATA!.ID: ${userData!.id}');
    var document2 =
        await collection.where('creator_id', isEqualTo: userData!.id).get();
    for (var doc in document2.docs) {
      var data = doc.data();
      tasks.add(TaskModel.fromJson(data));
    }

    return tasks;
  }

  static sendAlarm() async {
    var map = {
      "title": 'Deadline',
      "body": 'Task is still not complete',
    };
    var msg = {
      'action_type': 'new_user',
      'data': userData!.toJson(),
      'sound': FIREBASE_SOUND_NAME
    };

    await sendNotification(map, msg, userData!.id);
  }

  static sendNotification(var map, var data, var userId) async {
    String url = "https://fcm.googleapis.com/fcm/send";
    String token = await getFcmToken(Collections.FCM_TOKENS, userId);

    print('TOKEN: $token');
    var apiKey =
        'AAAAKV3X9-o:APA91bGhAk9YsHmVF0zv2rHBMZdtd7bTgiY6vbyNncvG79ldl9WmrjWLPwj33uNq1V5kuAjepZXXiGYZy2mIwEZN9h7Vcphj6VxMuyQ_eUCwui66yI7Il_yusnUa8yQT-2JetYOwxVs-';
    var apiData = {
      "to": token,
      "notification": {"title": map['title'], "body": map['body']},
      "data": data
    };

    print('APIDATA: $apiData');
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(apiData),
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json"
          });
      print('RESPONSE.BODY: ${response.body}');
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
