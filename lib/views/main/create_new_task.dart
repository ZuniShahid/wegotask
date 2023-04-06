import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../common/app_bar_widget.dart';
import '../../common/custom_dialog.dart';
import '../../common/custom_toast.dart';
import '../../common/date_time_functions.dart';
import '../../databse/collections.dart';
import '../../databse/data_helper.dart';
import '../../global_variables.dart';

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({super.key});

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  DateTime createdDate = DateTime.now();
  TimeOfDay dayOfWeek = TimeOfDay.now();
  String dropdownValue = 'Item 1';
  String dropdownvaluecountry = 'Only Can View Task';
  List<String> list = <String>['Only Can View Task', 'Can Can Edit Task'];
  bool repeatAlarm = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool taskPermission = false;

  final Color _fieldColor = const Color(0xFFEBEFF0);
  final TextEditingController _taskCreatedDate = TextEditingController();
  final TextEditingController _taskCreatedTime = TextEditingController();
  final TextEditingController _taskDayOfWeek = TextEditingController();
  final TextEditingController _taskDesc = TextEditingController();
  final TextEditingController _taskKey = TextEditingController();
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _taskUser = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'CREATE NEW TASK'),
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
              Container(
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
                        decoration:
                            const InputDecoration(border: InputBorder.none),
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
              Center(
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
                          _taskCreatedTime.text.isEmpty ||
                          _taskCreatedDate.text.isEmpty)
                      ? null
                      : () async {
                          CustomDialogBox.showLoading('Creating Task');
                          print('USERDATA!.ID: ${userData!.id}');
                          String docId = DataHelper.getNewDocId();
                          var taskModel = {
                            '_id': docId,
                            'creator_id': userData!.id,
                            'created_date': _taskCreatedDate.text,
                            'created_time': formatTimeOfDay(TimeOfDay.now()),
                            'created_day': _taskDayOfWeek.text,
                            'title': _taskTitle.text,
                            'desc': _taskDesc.text,
                            'task_permission': taskPermission,
                            'total_users': int.parse(_taskUser.text),
                            'active_users': 0,
                            'completed_status': false,
                            'alarm_time': _taskCreatedTime.text,
                            'repeat_alarm': repeatAlarm,
                            'users_list': [],
                          };

                          await DataHelper.addCollectionData(
                              Collections.TASKS, docId, taskModel);
                          _taskKey.text = docId;

                          _taskDesc.text = '';
                          _taskDayOfWeek.text = '';
                          _taskTitle.text = '';
                          _taskUser.text = '';
                          _taskCreatedTime.text = '';
                          _taskCreatedDate.text = '';
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: createdDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(3101),
    );
    if (picked != null && picked != createdDate) {
      setState(() {
        createdDate = DateTime(picked.year, picked.month, picked.day);
        _taskDayOfWeek.text = getDayOfWeek(picked);
        print('SELECTEDDATE: $createdDate');
        _taskCreatedDate.text = picked.toString().substring(0, 10);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _taskCreatedTime.text = selectedTime.format(context).toString();
        final dateFormat = DateFormat('h:mm a');
        final time = dateFormat.parse(_taskCreatedTime.text);
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
                      child: Center(
                        child: DropdownButtonFormField2(
                          buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.transparent))),
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
                          items: list
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
                              dropdownvaluecountry = newValue.toString();

                              if (newValue == 'Only Can View Task') {
                                taskPermission = false;
                              } else {
                                taskPermission = true;
                              }
                            });
                          },
                          onSaved: (newValue) {
                            setState(() {
                              dropdownvaluecountry = newValue.toString();

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
                      controller: _taskCreatedDate,
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
                      controller: _taskCreatedTime,
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
                      child: Center(
                        child: DropdownButtonFormField2(
                          buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.transparent))),
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
                          items: list
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
                          validator: (value) {
                            if (dropdownvaluecountry == 'Country Name') {
                              return 'Please Select Country';
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            setState(() {
                              dropdownvaluecountry = newValue.toString();
                            });
                          },
                          onSaved: (newValue) {
                            setState(() {
                              dropdownvaluecountry = newValue.toString();
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
