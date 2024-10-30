import 'package:flutter/material.dart';

class CircleBackButton extends StatelessWidget {
  final Color? color;
  const CircleBackButton({this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: color ?? Colors.white,
          ),
        ));
  }
}
