import 'package:flutter/material.dart';

class TaskModel {
  TaskModel({
    this.id,
    this.creatorId,
    this.createdDate,
    this.createdTime,
    this.createdDay,
    this.title,
    this.desc,
    this.taskPermission,
    this.totalUsers,
    this.activeUsers,
    this.completedStatus,
    this.alarmTime,
    this.repeatAlarm,
    this.usersList,
  });

  String? id;
  String? creatorId;
  String? createdDate;
  String? createdTime;
  String? createdDay;
  String? title;
  String? desc;
  bool? taskPermission;
  int? totalUsers;
  int? activeUsers;
  bool? completedStatus;
  String? alarmTime;
  bool? repeatAlarm;
  List<String>? usersList;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        creatorId: json["creator_id"],
        createdDate: json["created_date"],
        createdTime: json["created_time"],
        createdDay: json["created_day"],
        title: json["title"],
        desc: json["desc"],
        taskPermission: json["task_permission"],
        totalUsers: json["total_users"],
        activeUsers: json["active_users"],
        completedStatus: json["completed_status"],
        alarmTime: json["alarm_time"],
        repeatAlarm: json["repeat_alarm"],
        usersList: List<String>.from(json["users_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creator_id": creatorId,
        "created_date": createdDate,
        "created_time": createdTime,
        "created_day": createdDay,
        "title": title,
        "desc": desc,
        "task_permission": taskPermission,
        "total_users": totalUsers,
        "active_users": activeUsers,
        "completed_status": completedStatus,
        "alarm_time": alarmTime,
        "repeat_alarm": repeatAlarm,
        "users_list": List<dynamic>.from(usersList!.map((x) => x)),
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
