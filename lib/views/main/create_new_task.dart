import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../common/app_bar_widget.dart';
import '../../common/colors.dart';
import '../../common/custom_dialog.dart';
import '../../common/custom_toast.dart';
import '../../common/date_time_functions.dart';
import '../../controller/general_controller.dart';
import '../../databse/collections.dart';
import '../../databse/data_helper.dart';
import '../../global_variables.dart';
import '../../models/task_history_model.dart';
import 'chat_box.dart';
import 'home_page.dart';

class CreateNewTask extends StatefulWidget {
  final bool? viewTask;
  final bool? acceptReject;
  final TaskModel? taskModel;

  const CreateNewTask(
      {super.key,
      this.viewTask = false,
      this.taskModel,
      this.acceptReject = false});

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final GeneralController _controller = Get.find<GeneralController>();
  DateTime endDate = DateTime.now();
  TimeOfDay dayOfWeek = TimeOfDay.now();

  String permissionDropDown = 'Only Can View Task';
  List<String> permissionDropDownList = <String>[
    'Only Can View Task',
    'Can Can Edit Task'
  ];

  String intervalDropDown = 'Only Can View Task';
  List<String> intervalDropDownList = <String>['15 min', '30 min'];

  final bool _repeatAlarm = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool taskPermission = false;
  bool isCompleted = false;
  bool myTaskCompleted = false;

  final Color _fieldColor = const Color(0xFFEBEFF0);
  final TextEditingController _taskendDate = TextEditingController();
  final TextEditingController _taskendTime = TextEditingController();
  final TextEditingController _taskDayOfWeek = TextEditingController();
  final TextEditingController _taskDesc = TextEditingController();
  final TextEditingController _taskKey = TextEditingController();
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _taskUser = TextEditingController();
  final TextEditingController _taskInterval = TextEditingController();
  bool _viewTask = false;
  @override
  void initState() {
    if (widget.viewTask! == true) {
      _viewTask = true;
      TaskModel taskModel = widget.taskModel!;
      _taskendDate.text = taskModel.endDate.toString();
      _taskendTime.text = taskModel.endTime.toString();
      _taskDayOfWeek.text = taskModel.endDay.toString();
      _taskDesc.text = taskModel.desc.toString();
      _taskTitle.text = taskModel.title.toString();
      _taskUser.text = taskModel.totalUsers.toString();
      _taskKey.text = taskModel.id.toString();
      taskPermission = taskModel.taskPermission!;
      isCompleted = taskModel.completedStatus!;
      for (int i = 0; i < taskModel.activeUserTaskStatus!.length; i++) {
        if (taskModel.activeUserTaskStatus![i].uid == userData!.id) {
          myTaskCompleted = taskModel.activeUserTaskStatus![i].taskStatus!;
        }
      }

      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'CREATE NEW TASK',
        onPressed: () {
          Get.offAll(const HomePage());
        },
        chatButton: _viewTask,
        chatOnPressed: () {
          Get.to(() => ChatBox(
                taskModel: widget.taskModel!,
              ));
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADD DETAIL OF TASK',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _taskInfo(),
              const SizedBox(height: 15),
              _inputs(),
              const SizedBox(height: 15),
              _viewTask
                  ? const SizedBox.shrink()
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: _taskKey,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: _taskKey.text));
                              CustomToast.successToast(message: 'Copied');
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
              const SizedBox(height: 15),
              widget.acceptReject == true
                  ? Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(55.w, 6.h),
                              maximumSize: Size(55.w, 6.h),
                            ),
                            onPressed: isCompleted
                                ? null
                                : () async {
                                    if (await DataHelper.addInTask(
                                            Collections.TASKS,
                                            'id',
                                            widget.taskModel!.id.toString()) ==
                                        1) {
                                      _controller.taskList.value =
                                          await DataHelper
                                              .fetchTasksFromCollection(
                                                  Collections.TASKS,
                                                  'users_list',
                                                  userData!.id.toString());
                                      setState(() {});
                                      Get.offAll(() => const HomePage());
                                    } else {}
                                  },
                            child: Center(
                              child: Text(
                                isCompleted
                                    ? 'Task is Already mark as Completed'
                                    : 'Add in Task',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        isCompleted
                            ? const SizedBox.shrink()
                            : Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    minimumSize: Size(55.w, 6.h),
                                    maximumSize: Size(55.w, 6.h),
                                  ),
                                  onPressed: () async {
                                    Get.offAll(() => const HomePage());
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Reject Task',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )
                  : const SizedBox.shrink(),
              _viewTask && widget.acceptReject == false
                  ? Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCompleted
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(55.w, 6.h),
                              maximumSize: Size(55.w, 6.h),
                            ),
                            onPressed: isCompleted
                                ? () {}
                                : () async {
                                    if (taskPermission == true) {
                                      await DataHelper.updateQuery(
                                          Collections.TASKS,
                                          _taskKey.text,
                                          'completed_status',
                                          true);
                                      Get.offAll(() => const HomePage());
                                    } else {
                                      CustomToast.errorSnackBar(
                                          context: context,
                                          text:
                                              'You are not allowed to mark whole task as Complete');
                                    }
                                  },
                            child: Center(
                              child: Text(
                                isCompleted
                                    ? 'Already Completed'
                                    : 'Mark as Complete',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCompleted
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(55.w, 6.h),
                              maximumSize: Size(55.w, 6.h),
                            ),
                            onPressed: myTaskCompleted
                                ? null
                                : () async {
                                    await DataHelper.updateMapList(
                                        widget.taskModel!.id.toString());

                                    Get.offAll(() => const HomePage());
                                  },
                            child: Center(
                              child: Text(
                                myTaskCompleted
                                    ? 'My Task Already Completed'
                                    : 'Mark my Task as Complete',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              _viewTask == false && widget.acceptReject == false
                  ? Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(35.w, 6.h),
                          maximumSize: Size(35.w, 6.h),
                        ),
                        onPressed: (_taskDesc.text.isEmpty ||
                                _taskDayOfWeek.text.isEmpty ||
                                _taskTitle.text.isEmpty ||
                                _taskUser.text.isEmpty ||
                                _taskendTime.text.isEmpty ||
                                _taskendDate.text.isEmpty)
                            ? null
                            : () async {
                                CustomDialogBox.showLoading('Creating Task');
                                print('USERDATA!.ID: ${userData!.id}');
                                String docId = DataHelper.getNewDocId();

                                var taskModel = {
                                  'id': docId,
                                  'creator_id': userData!.id,
                                  'end_date': _taskendDate.text,
                                  'end_time': formatTimeOfDay(TimeOfDay.now()),
                                  'end_day': _taskDayOfWeek.text,
                                  'title': _taskTitle.text,
                                  'desc': _taskDesc.text,
                                  'task_permission': taskPermission,
                                  'total_users': int.parse(_taskUser.text),
                                  'active_users': 0,
                                  'completed_status': false,
                                  'alarm_time': _taskendTime.text,
                                  'repeat_alarm': _repeatAlarm,
                                  'repeat_interval': _taskInterval.text,
                                  'users_list': [],
                                  'fcm_token_list': [],
                                };
                                await DataHelper.addCollectionData(
                                    Collections.TASKS, docId, taskModel);
                                Get.find<GeneralController>().taskList.value =
                                    await DataHelper.fetchTasksFromCollection(
                                        Collections.TASKS,
                                        'users_list',
                                        userData!.id.toString());
                                Get.find<GeneralController>()
                                    .taskList
                                    .refresh();

                                _taskKey.text = docId;

                                await Clipboard.setData(
                                    ClipboardData(text: _taskKey.text));
                                CustomToast.successToast(
                                    message: 'Task Key is Copied');

                                _taskDesc.text = '';
                                _taskDayOfWeek.text = '';
                                _taskTitle.text = '';
                                _taskUser.text = '';
                                _taskendTime.text = '';
                                _taskendDate.text = '';
                                _taskInterval.text = '';
                                CustomDialogBox.hideLoading();

                                setState(() {});
                              },
                        child: const Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_viewTask) {
      return;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(3101),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = DateTime(picked.year, picked.month, picked.day);
        _taskDayOfWeek.text = getDayOfWeek(picked);
        print('SELECTEDDATE: $endDate');
        _taskendDate.text = picked.toString().substring(0, 10);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (_viewTask) {
      return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _taskendTime.text = selectedTime.format(context).toString();
        final dateFormat = DateFormat('h:mm a');
        final time = dateFormat.parse(_taskendTime.text);
        print('Parsed Time: ${TimeOfDay.fromDateTime(time)}');
        print(
            'FORMATTIMEOFDAY(TIMEOFDAY.FROMDATETIME(TIME)): ${formatTimeOfDay(TimeOfDay.fromDateTime(time))}');
      });
    }
  }

  Column _inputs() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD USERS',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      readOnly: _viewTask,
                      controller: _taskUser,
                      style: const TextStyle(
                        color: Color(0xFF1E3333),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Users',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Permssions',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      child: _viewTask
                          ? TextField(
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xFF1E3333),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: taskPermission
                                    ? 'Task Can be view only'
                                    : 'Task can be share',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : Center(
                              child: DropdownButtonFormField2(
                                buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent))),
                                decoration: const InputDecoration(
                                  iconColor: Colors.grey,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  // border: OutlineInputBorder(),
                                ),
                                isExpanded: true,
                                hint: const Text(
                                  'Only Can View Task',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  iconSize: 30,
                                ),
                                items: permissionDropDownList
                                    .map((item) => DropdownMenuItem<dynamic>(
                                          value: item,
                                          child: Center(
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    permissionDropDown = newValue.toString();

                                    if (newValue == 'Only Can View Task') {
                                      taskPermission = false;
                                    } else {
                                      taskPermission = true;
                                    }
                                  });
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    permissionDropDown = newValue.toString();

                                    if (newValue == 'Only Can View Task') {
                                      taskPermission = false;
                                    } else {
                                      taskPermission = true;
                                    }
                                  });
                                },
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD DAY',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _taskDayOfWeek,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      style: const TextStyle(
                        color: Color(0xFF1E3333),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Day',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD DATE',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _taskendDate,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Color(0xFF1E3333),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Day',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD ALARM',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      onTap: () => _selectTime(context),
                      controller: _taskendTime,
                      readOnly: true,
                      style: const TextStyle(
                        color: Color(0xFF1E3333),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Alarm',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Repeat Interval',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w800),
                      ),
                      // Switch(
                      //   activeColor: Colors.amber,
                      //   activeTrackColor: Colors.cyan,
                      //   inactiveThumbColor: Colors.blueGrey,
                      //   inactiveTrackColor: Colors.grey,
                      //   splashRadius: 50.0,
                      //   value: _repeatAlarm,
                      //   onChanged: (value) =>
                      //       setState(() => _repeatAlarm = value),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _fieldColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _taskInterval,
                        style: const TextStyle(
                          color: Color(0xFF1E3333),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Interval in Minutes',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _taskInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 4, 15, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              readOnly: _viewTask,
              controller: _taskTitle,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
                hintText: 'TITLE OF TASK',
                border: InputBorder.none,
              ),
            ),
            TextField(
              readOnly: _viewTask,
              onChanged: (v) {
                setState(() {});
              },
              maxLines: 4,
              maxLength: 100,
              controller: _taskDesc,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                counter: Text('${_taskDesc.text.length}/100 Words',
                    style: const TextStyle(color: Colors.white)),
                hintMaxLines: 3,
                hintStyle: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
                hintText:
                    'Type your task here.for example: I need to pickup school book bag.etc',
                border: InputBorder.none,
              ),
            ),
          ]),
    );
  }
}
