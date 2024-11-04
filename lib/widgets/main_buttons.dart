import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final Function onPressed;

  MainButton({
    required this.width,
    required this.height,
    required this.child,
    required this.color,
    required this.onPressed,
    required this.padding});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: child,
        style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90),
      )
    ),);
  }
}
