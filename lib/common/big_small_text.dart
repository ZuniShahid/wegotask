import 'package:flutter/material.dart';

class BigSmallText extends StatelessWidget {
  final String text;

  const BigSmallText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> words = text.split(' ');

    if (words.length == 1) {
      return Text(
        words[0],
        style: const TextStyle(
          color: Colors.white,
          letterSpacing: 2,
          fontSize: 23,
          fontWeight: FontWeight.w800,
        ),
        maxLines: 1,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: words.map((word) {
        if (word == words.first) {
          return Text(
            word,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1), // add some height between lines
            Text(
              word,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
          ],
        );
      }).toList(),
    );
  }
}
