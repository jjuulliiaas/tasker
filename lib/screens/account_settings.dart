import 'package:flutter/material.dart';
import 'package:tasker/widgets/top_container.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import 'package:tasker/widgets/main_buttons.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
          contentPadding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
          title: StyledText.accentLabel(text: "Are you sure?", color: Colors.black,),
          content: StyledText.defaultLabel(text: "Your account will be deleting permanently.", color: Colors.black,),
          actions: [
            OutlinedButton(
              child: StyledText.accentLabel(text: 'Cancel', color: ColorsList.kLightGreen),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 30,),
            MainButton(
                width: 30,
                height: 6,
                child: StyledText.accentLabel(text: 'Delete', color: Colors.white),
                color: ColorsList.kRed,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                onPressed: () {
                  // TO DO actions for deleting account
                },
                )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: Column(
        children: [
          TopContainer(
              width: MediaQuery.of(context).size.width,
              height: 280,
              color: ColorsList.kLightestGreen,
              padding: EdgeInsets.only(left: 30.0, top: 50.0, bottom: 20.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 25,)),
                  Center(
                    child: CircleAvatar(
                    backgroundColor: ColorsList.kAppBackground,
                    radius: 50),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: StyledText.mainHeading(text: 'User Name', color: Colors.white),
                  ),
                ],
              )),
          SizedBox(height: 30,),
          StyledText.accentLabel(text: 'You can also delete your account', color: ColorsList.kDarkGreen,),
          SizedBox(height: 30,),
          MainButton(
              width: 35,
              height: 10,
              child: StyledText.accentLabel(text: 'Delete Account', color: Colors.white),
              color: ColorsList.kRed,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              onPressed: () {
                _showAlertDialog(context);
              }
              ),
        ],
      ),
    );
  }
}