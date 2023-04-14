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
    this.repeatInterval,
    this.usersList,
    this.fcmTokenList,
    this.messageModelList,
    this.activeUserTaskStatus,
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
  String? repeatInterval;
  bool? repeatAlarm;
  List<String>? usersList;
  List<String?>? fcmTokenList;
  List<MessageModel>? messageModelList;
  List<ActiveUserTaskStatus>? activeUserTaskStatus;

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
        repeatInterval: json["repeat_interval"],
        usersList: json["users_list"] == null
            ? []
            : List<String>.from(json["users_list"].map((x) => x)),
        fcmTokenList: json["fcm_token_list"] == null
            ? <String>[]
            : List<String>.from(json["fcm_token_list"].map((x) => x)),
        activeUserTaskStatus: json["active_user_task_status"] == null
            ? []
            : List<ActiveUserTaskStatus>.from(json["active_user_task_status"]
                .map((x) => ActiveUserTaskStatus.fromJson(x))),
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
        "repeat_interval": repeatInterval,
        "users_list": List<dynamic>.from(usersList!.map((x) => x)),
        "fcm_token_list": List<dynamic>.from(fcmTokenList!.map((x) => x)),
      };
}

class ActiveUserTaskStatus {
  ActiveUserTaskStatus({
    this.uid,
    this.taskStatus,
  });

  String? uid;
  bool? taskStatus;

  factory ActiveUserTaskStatus.fromJson(Map<String, dynamic> json) =>
      ActiveUserTaskStatus(
        uid: json["_uid"],
        taskStatus: json["task_status"],
      );

  Map<String, dynamic> toJson() => {
        "_uid": uid,
        "task_status": taskStatus,
      };
}
