import 'package:flutter/material.dart';

class CustomColorPicker extends StatefulWidget {
  const CustomColorPicker({super.key});

  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  Offset selectedPosition = const Offset(0, 0); // Tracks the selected position

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Update the selected position based on the user's drag
          selectedPosition += details.delta;
          // Clamp the position to stay within the color picker bounds
          selectedPosition = Offset(
            selectedPosition.dx
                .clamp(0, MediaQuery.of(context).size.width * 0.3),
            selectedPosition.dy
                .clamp(0, MediaQuery.of(context).size.height / 2),
          );
        });
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width * 0.3,
            MediaQuery.of(context).size.height / 2),
        painter: ColorPickerPainter(selectedPosition),
      ),
    );
  }
}

class ColorPickerPainter extends CustomPainter {
  final Offset selectedPosition;

  ColorPickerPainter(this.selectedPosition);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the color picker container
    Paint containerPaint = Paint()..color = Colors.grey;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), containerPaint);

    // Draw the selected color indicator
    Paint selectedColorPaint = Paint()..color = Colors.red;
    canvas.drawCircle(selectedPosition, 10, selectedColorPaint);
  }

  @override
  bool shouldRepaint(ColorPickerPainter oldDelegate) {
    return oldDelegate.selectedPosition != selectedPosition;
  }
}
