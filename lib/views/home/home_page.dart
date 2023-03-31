import 'package:flutter/material.dart';
import 'package:wegotask/common/colors.dart';

import '../../common/input_decorations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
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
                const SizedBox(height: 40),
                Container(
                  height: 146,
                  width: 146,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00D2F3),
                  ),
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
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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
                          // controller: idController,
                          cursorColor: Colors.grey,
                          decoration: InputDecorations.inputDecorationAllBorder(
                            hintText: 'Paste Code Here',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'TASK HISTORY',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                    Text(
                      'SEE ALL',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 13),
                    )
                  ],
                ),
                const SizedBox(height: 40),
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
                Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
