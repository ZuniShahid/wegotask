import 'package:alarm/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common/big_small_text.dart';
import '../../common/colors.dart';
import '../../common/custom_dialog.dart';
import '../../common/gradient_text.dart';
import '../../common/input_decorations.dart';
import '../../controller/general_controller.dart';
import '../../databse/collections.dart';
import '../../databse/data_helper.dart';
import '../../global_variables.dart';
import '../../models/task_history_model.dart';
import '../auth/login_screen.dart';
import 'create_new_task.dart';
import 'task_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final alarmSettings = AlarmSettings(
    id: 42,
    dateTime: DateTime.now(),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: 'This is the title',
    notificationBody: 'This is the body',
    enableNotificationOnKill: true,
  );

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController _taskKey = TextEditingController();

  final GeneralController _controller = GeneralController();
  bool dataLoading = false;

  callApi() async {
    setState(() {
      dataLoading = true;
    });
    _controller.taskList.value = await DataHelper.fetchTasksFromCollection(
        Collections.TASKS, 'users_list', userData!.id.toString());
    setState(() {
      dataLoading = false;
    });
  }

  @override
  void initState() {
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
        IconButton(
            onPressed: () async {
              DataHelper.updateFcmToken(
                  Collections.FCM_TOKENS, userData!.id, '');
              FirebaseAuth.instance.signOut();
              setUserLoggedIn(false);
              Get.offAll(const LoginScreen());
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.primary,
            )),
      ]),
      body: RefreshIndicator(
        onRefresh: () async {
          callApi();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const CreateNewTask());
                    },
                    child: Container(
                      height: 73,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E3333),
                        borderRadius: BorderRadius.all(
                          Radius.circular(93),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    'CREATE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1),
                                  ),
                                  Text(
                                    'NEW TASK',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2),
                                  )
                                ],
                              ),
                              Image.asset(
                                'assets/icons/create_arrow.png',
                                width: 38,
                                height: 23,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // FlipCard(
                  //   key: cardKey,
                  //   flipOnTouch: false,
                  //   front: InkWell(
                  //     onTap: () => cardKey.currentState!.toggleCard(),
                  //     child: _assignTaskCircle(),
                  //   ),
                  //   back: InkWell(
                  //       onTap: () => cardKey.currentState!.toggleCard(),
                  //       child: assingNewTask()),
                  // ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 56,
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _taskKey,
                            cursorColor: Colors.grey,
                            decoration:
                                InputDecorations.inputDecorationAllBorder(
                              hintText: 'Paste Code Here',
                            ).copyWith(
                                    hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        CustomDialogBox.showLoading('Loading');
                        var taskModel = await DataHelper.searchTask(
                            Collections.TASKS, 'id', _taskKey.text);
                        CustomDialogBox.hideLoading();
                        if (taskModel != 0) {
                          Get.to(() => CreateNewTask(
                                taskModel: taskModel,
                                viewTask: true,
                                acceptReject: true,
                              ));
                          print('TASKMODEL: ${taskModel.id}');
                          setState(() {});
                        }

                        CustomDialogBox.hideLoading();

                        // ByteData soundData =
                        //     await rootBundle.load('assets/sounds/alarm.mp3');

                        // Directory tempDir = await getTemporaryDirectory();

                        // File soundFile =
                        //     File('${tempDir.path}/alarm.mp3');

                        // await soundFile
                        //     .writeAsBytes(soundData.buffer.asUint8List());

                        // AndroidNotificationDetails
                        //     androidPlatformChannelSpecifics =
                        //     const AndroidNotificationDetails(
                        //         'high_importance_channel',
                        //         'High Importance Notifications',
                        //         importance: Importance.high,
                        //         priority: Priority.high,
                        //         sound: RawResourceAndroidNotificationSound(
                        //             'assets/sounds/alarm.mp3'), // Set the custom sound
                        //         icon: "app_icon");
                        // NotificationDetails platformChannelSpecifics =
                        //     NotificationDetails(
                        //         android: androidPlatformChannelSpecifics);
                        // await FlutterLocalNotificationsPlugin().show(
                        //   0,
                        //   'Notification Title',
                        //   'Notification Body',
                        //   platformChannelSpecifics,
                        //   payload: 'your_notification_payload',
                        // );
                      },
                      child: const Text('Submit')),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          // await Alarm.set(alarmSettings: alarmSettings);
                        },
                        child: const Text(
                          'TASK HISTORY',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          _controller.taskList.value =
                              await DataHelper.fetchTasksFromCollection(
                                  Collections.TASKS,
                                  'users_list',
                                  userData!.id.toString());
                          setState(() {});
                          Get.to(() => TaskHistoryPage(
                                taskList: _controller.taskList,
                              ));
                        },
                        child: const Text(
                          'SEE ALL',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Obx(
                    () => Container(
                      child: _controller.taskList.isEmpty
                          ? Column(
                              children: [
                                Image.asset(
                                  'assets/icons/no_task_history.png',
                                  width: 234,
                                  height: 163,
                                ),
                                const SizedBox(height: 40),
                                const Text(
                                  'NO TASK HISTORY',
                                  style: TextStyle(
                                      color: AppColors.appGrey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                                ),
                              ],
                            )
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: _controller.taskList.length,
                              itemBuilder: (BuildContext context, int index) {
                                TaskModel taskHistory =
                                    _controller.taskList[index];
                                List<String> parts =
                                    taskHistory.title!.split(' ');
                                return InkWell(
                                  onTap: () async {
                                    Get.to(() => CreateNewTask(
                                          viewTask: true,
                                          taskModel: taskHistory,
                                        ));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          14, 11, 9, 2),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    taskHistory.endDate
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    taskHistory.endTime
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          BigSmallText(
                                              text:
                                                  taskHistory.title.toString()),
                                          FittedBox(
                                            fit: BoxFit.contain,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: taskHistory
                                                                .completedStatus!
                                                            ? AppColors
                                                                .secondary
                                                            : AppColors.primary,
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: Text(
                                                        ' + ${taskHistory.totalUsers}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    taskHistory.completedStatus!
                                                        ? 'COMPLETED'
                                                        : 'INCOMPLETED',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container assingNewTask() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF00D2F3),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(
              0.0,
              4.0,
            ),
            blurRadius: 4.0,
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
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'ASSING',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Text(
            'NEW TASK',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    controller: _taskKey,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: _taskKey.text));
                  },
                  child: const Icon(
                    Icons.copy_rounded,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF00D2F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(55.w, 6.h),
                maximumSize: Size(55.w, 6.h),
              ),
              onPressed: () {},
              child: const Center(
                child: Text(
                  'COPY CODE',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildText(parts, text) {
    if (parts.length > 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parts[0],
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              parts.sublist(1).join(' '),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          letterSpacing: 2,
          fontSize: 23,
          fontWeight: FontWeight.w800,
        ),
      );
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
      });
    }
  }

  Container _assignTaskCircle() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF00D2F3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(
              0.0,
              4.0,
            ),
            blurRadius: 4.0,
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
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.add,
            size: 66,
            color: Colors.white,
          ),
          Text(
            'ASSIGN TASK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
