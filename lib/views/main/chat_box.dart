import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../common/colors.dart';
import '../../common/input_decorations.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Houcine Ncib',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Lato',
                color: Colors.black,
              ),
            ),
            Text(
              'Online',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Lato',
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: AppColors.chatColor,
      ),
      body: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final int sendCount = 8;

  final int reciveCount = 8;

  final TextEditingController _typeMessageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: ListView(
          children: <Widget>[
            Center(
              child: DateChip(
                color: Colors.transparent,
                date: DateTime(now.year, now.month, now.day - 1),
              ),
            ),
            ListView.builder(
              itemCount: 20,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return index % 2 == 0
                    ? getSenderView(
                        'hello mike, you need ac spit mitsudis.....???. i have best deal for you. ')
                    : getReceiverView(
                        'hello mike, you need ac spit mitsudis.....???. i have best deal for you. ');
              },
            ),
          ],
        ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 64,
            width: 100.w,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.textFieldColor,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.keyboard,
                          color: _typeMessageController.text == ''
                              ? AppColors.appGrey
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _typeMessageController,
                            // validator: (value) => CustomValidator.email(value),
                            cursorColor: Colors.grey,
                            decoration:
                                InputDecorations.inputDecorationAllBorder(
                              hintText: 'type your text here....'.toUpperCase(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 13,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle, color: Colors.black),
                  child: Transform.rotate(
                    angle: _typeMessageController.text.isNotEmpty ? 5.5 : 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
    ]);
  }

  getTitleText(String title) => Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      );

  getSenderView(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Image.asset(
                  'assets/icons/double_tick.png',
                  width: 14,
                  height: 8,
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: BubbleSpecialOne(
                text: text,
                isSender: true,
                color: AppColors.chatColor,
                textStyle: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/icons/no_task_history.png')),
          ],
        ),
      );

  getReceiverView(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/icons/no_task_history.png')),
            Expanded(
              child: BubbleSpecialOne(
                text: text,
                isSender: false,
                color: AppColors.chatColor,
                textStyle: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Image.asset(
                  'assets/icons/double_tick.png',
                  width: 14,
                  height: 8,
                ),
              ],
            ),
          ],
        ),
      );
}
