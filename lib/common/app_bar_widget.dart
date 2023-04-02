import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/main/chat_box.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;

  AppBarWidget({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Image.asset('assets/icons/back_button.png'),
          onPressed: () {
            Get.back();
          }),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      actions: [
        IconButton(
            icon: Image.asset('assets/icons/message_icon.png'),
            onPressed: () {
              Get.to(() => const ChatBox());
            }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
