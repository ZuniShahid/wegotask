import 'package:flutter/material.dart';

import 'user_model.dart';

class TaskModel {
  TaskModel({
    this.title,
    this.desc,
    this.uid,
    this.createdDate,
    this.createdTime,
    this.permission,
    this.completedStatus,
    this.totalUsers,
    this.activeUsers,
    this.user,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json, {var user}) => TaskModel(
        title: json["title"],
        desc: json["desc"],
        uid: json["_uid"],
        createdDate: json["created_date"],
        createdTime: json["created_time"],
        permission: json["permission"],
        completedStatus: json["completed_status"],
        totalUsers: json["total_users"],
        activeUsers: json["active_users"],
        user: user,
      );

  int? activeUsers;
  bool? completedStatus;
  String? createdDate;
  String? createdTime;
  String? desc;
  bool? permission;
  String? title;
  int? totalUsers;
  String? uid;
  UserModel? user;

  Map<String, dynamic> toJson() => {
        "title": title,
        "desc": desc,
        "_uid": uid,
        "created_date": createdDate,
        "created_time": createdTime,
        "permission": permission,
        "completed_status": completedStatus,
        "total_users": totalUsers,
        "active_users": activeUsers,
        "user": user?.toJson(),
      };
}

List<TaskModel> tempTaskHistory = [
  TaskModel(
      createdDate: DateTime.now().toString().substring(0, 10),
      createdTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      createdDate: DateTime.now().toString().substring(0, 10),
      createdTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      createdDate: DateTime.now().toString().substring(0, 10),
      createdTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      createdDate: DateTime.now().toString().substring(0, 10),
      createdTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      createdDate: DateTime.now().toString().substring(0, 10),
      createdTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
];
