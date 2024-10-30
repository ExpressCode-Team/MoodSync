import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  const BasicAppButton(
      {required this.onPressed,
      required this.title,
      this.height,
      this.fontSize,
      this.fontWeight,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          foregroundColor: color ?? Colors.black,
          minimumSize: Size.fromHeight(height ?? 72),
          textStyle: TextStyle(
            fontSize: fontSize ?? 24,
            color: color ?? Colors.black,
            fontWeight: fontWeight ?? FontWeight.normal,
            fontFamily: 'Montserrat',
          )),
      child: Text(
        title,
      ),
    );
  }
}
