import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final double expandedHeight;
  final Widget? flexibleChild;
  final Widget title;
  final Color backgroundColor;
  final bool pinned;
  final bool floating;

  CustomSliverAppBar({
    required this.expandedHeight,
    required this.title,
    this.flexibleChild,
    this.backgroundColor = Colors.blue,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double top = constraints.biggest.height;
          bool isCollapsed = top <= kToolbarHeight + MediaQuery.of(context).padding.top;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: expandedHeight,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
              ),

              // flexible content
              Positioned(
                left: 20.0,
                top: 50.0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 100),
                  opacity: isCollapsed ? 0.0 : 1.0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: expandedHeight - 40),
                    child: flexibleChild ?? Container(),
                  ),
                ),
              ),

              // title (non-flexible content)
              Positioned(
                left: 25.0,
                bottom: 10.0,
                child: title,
              ),
            ],
          );
        },
      ),
    );
  }
}
