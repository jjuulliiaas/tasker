import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final TextStyle style;

  StyledText({required this.text, required this.style});


  // page titles:
  StyledText.mainHeading({required this.text, required Color color})
      : style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: color,
  );

  // default labels like date, e-mail, titles etc.:
  StyledText.defaultLabel({required this.text, required Color color})
      : style = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: color,
  );

  // accent labels:
  StyledText.accentLabel({required this.text, required Color color})
      : style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
