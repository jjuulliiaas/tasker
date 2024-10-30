import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final TextStyle style;

  StyledText({required this.text, required this.style});

  StyledText.mainHeading({required this.text, required Color color})
      : style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: color,
  );

  StyledText.defaultLabel({required this.text, required Color color})
      : style = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
