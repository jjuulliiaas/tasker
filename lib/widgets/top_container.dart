import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  TopContainer({
    required this.width,
    required this.height,
    required this.child,
    required this.color,
    required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
