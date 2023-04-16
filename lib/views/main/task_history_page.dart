import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_bar_widget.dart';
import '../../common/big_small_text.dart';
import '../../common/colors.dart';
import '../../common/gradient_text.dart';
import '../../models/task_history_model.dart';
import 'create_new_task.dart';

class TaskHistoryPage extends StatefulWidget {
  final List<TaskModel> taskList;
  const TaskHistoryPage({super.key, required this.taskList});

  @override
  State<TaskHistoryPage> createState() => _TaskHistoryPageState();
}

class _TaskHistoryPageState extends State<TaskHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'TASK HISTORY',
        chatButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.taskList.length,
            itemBuilder: (BuildContext context, int index) {
              TaskModel taskHistory = widget.taskList[index];
              return InkWell(
                onTap: () {
                  Get.to(() => CreateNewTask(
                        viewTask: true,
                        taskModel: taskHistory,
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 11, 9, 5),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: taskHistory.completedStatus!
                        ? AppColors.secondary
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(3.0, 3.0),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.w800,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(1),
                                    Colors.white.withOpacity(0),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              BigSmallText(text: taskHistory.title.toString()),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                taskHistory.endDate.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                taskHistory.endTime.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Note:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        taskHistory.desc!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            taskHistory.completedStatus!
                                ? 'Status: COMPLETED'
                                : 'Status: INCOMPLETED',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
