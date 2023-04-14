import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wegotask/databse/data_helper.dart';
import 'package:wegotask/global_variables.dart';
import 'package:wegotask/models/message_model.dart';

import '../../common/colors.dart';
import '../../common/input_decorations.dart';
import '../../models/task_history_model.dart';

class ChatBox extends StatefulWidget {
  final TaskModel taskModel;
  const ChatBox({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _typeMessageController = TextEditingController();

  getSenderView(MessageModel message) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: BubbleSpecialOne(
                text: message.messageText!,
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

  getReceiverView(MessageModel message) => Container(
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
                text: message.messageText!,
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
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Lato',
              color: Colors.black,
            ),
          ),
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: AppColors.chatColor,
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: ListView(
              children: <Widget>[
                Center(
                  child: DateChip(
                    color: Colors.transparent,
                    date: DateTime.now(),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(widget.taskModel.id)
                      .collection('messages')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No messages found.');
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index].data();
                        MessageModel message =
                            MessageModel.fromJson(data as Map<String, dynamic>);

                        return message.senderId == userData!.id
                            ? getSenderView(message)
                            : getReceiverView(message);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 74,
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
                                controller: _typeMessageController,
                                cursorColor: Colors.grey,
                                decoration:
                                    InputDecorations.inputDecorationAllBorder(
                                  hintText:
                                      'type your text here....'.toUpperCase(),
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
                      child: GestureDetector(
                        onTap: () {
                          if (_typeMessageController.text.isNotEmpty) {
                            sendMessage(_typeMessageController.text);
                            _typeMessageController.clear();
                          }
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }

  void sendMessage(String message) {
    String newDocId = DataHelper.getNewDocId();
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskModel.id)
        .collection('messages')
        .doc(newDocId)
        .set({
      "_id": newDocId,
      "message": message,
      "sender_id": userData!.id,
      "image": "",
      'created_at': DateTime.now()
    });
  }
}
