import 'package:flutter/material.dart';

import 'message_model.dart';

class TaskModel {
  TaskModel({
    this.id,
    this.creatorId,
    this.endDate,
    this.endTime,
    this.endDay,
    this.title,
    this.desc,
    this.taskPermission,
    this.totalUsers,
    this.activeUsers,
    this.completedStatus,
    this.alarmTime,
    this.repeatAlarm,
    this.usersList,
    this.messageModelList,
  });

  String? id;
  String? creatorId;
  String? endDate;
  String? endTime;
  String? endDay;
  String? title;
  String? desc;
  bool? taskPermission;
  int? totalUsers;
  int? activeUsers;
  bool? completedStatus;
  String? alarmTime;
  bool? repeatAlarm;
  List<String>? usersList;
  List<MessageModel>? messageModelList;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        creatorId: json["creator_id"],
        endDate: json["end_date"],
        endTime: json["end_time"],
        endDay: json["end_day"],
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
        "end_date": endDate,
        "end_time": endTime,
        "end_day": endDay,
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
      endDate: DateTime.now().toString().substring(0, 10),
      endTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      endDate: DateTime.now().toString().substring(0, 10),
      endTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      endDate: DateTime.now().toString().substring(0, 10),
      endTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      endDate: DateTime.now().toString().substring(0, 10),
      endTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
  TaskModel(
      endDate: DateTime.now().toString().substring(0, 10),
      endTime: TimeOfDay.now().toString().substring(0, 10),
      title: 'UTLITIES BILLS & FILLING GAS',
      desc:
          'Shopping utilties item then pay the Internet Bills and at last Fill Gas in calander from Gas Station.',
      totalUsers: 03,
      completedStatus: true),
];
