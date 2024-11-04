import 'package:flutter/material.dart';


class CustomSliverAppBar extends StatelessWidget {
  final double expandedHeight;
  final Widget? flexibleChild;
  final Widget? title;
  final Color backgroundColor;
  final bool pinned;
  final bool floating;

  CustomSliverAppBar({
    required this.expandedHeight,
    this.flexibleChild,
    this.title,
    this.backgroundColor = Colors.blue,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColor,
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      flexibleSpace: FlexibleSpaceBar(
        title: title,
        background: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.only(left: 30.0, bottom: 10.0, top: 60.0),
          child: flexibleChild,
        ),
      ),
    );
  }
}
