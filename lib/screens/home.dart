import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/top_container.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: SafeArea(
        child: Column(
          children: <Widget> [
            TopContainer(
                width: width,
                height: 215.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    IconButton(onPressed: () {
                      // TO DO actions
                    },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.view_headline_rounded),
                      iconSize: 50,
                      color: ColorsList.kAuthBackground,),
                    SizedBox(height: 50,),
                    StyledText.defaultLabel(text: 'Date', color: ColorsList.kAppBackground,),
                    StyledText.mainHeading(text: 'My Tasks', color: Colors.white,)
                  ],
                ),
                color: ColorsList.kDarkGreen,
                padding: const EdgeInsets.only(left: 30.0, top: 20.0))
          ],
        ),
      ),
    );
  }
}
