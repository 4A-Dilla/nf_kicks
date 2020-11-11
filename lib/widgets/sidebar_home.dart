import 'package:flutter/material.dart';

import 'sidebar_button.dart';
import 'constants.dart';

enum CategoryEnum { gym, running, trainers, style }

class SidebarHome extends StatefulWidget {
  @override
  _SidebarHomeState createState() => _SidebarHomeState();
}

class _SidebarHomeState extends State<SidebarHome> {
  CategoryEnum categoryEnum;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: -1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SidebarButton(
              text: "RUNNING",
              onSelected: () {
                setState(() {
                  categoryEnum = CategoryEnum.running;
                });
              },
              border: categoryEnum == CategoryEnum.running
                  ? kActiveButtonBorderColor
                  : kInactiveButtonBorderColor,
              color: categoryEnum == CategoryEnum.running
                  ? kActiveBtnColor
                  : kInactiveBtnColor,
              textColor: categoryEnum == CategoryEnum.running
                  ? kActiveBtnTextColor
                  : kInactiveBtnTextColor,
            ),
            SidebarButton(
              text: "Gym",
              onSelected: () {
                setState(() {
                  categoryEnum = CategoryEnum.gym;
                });
              },
              border: categoryEnum == CategoryEnum.gym
                  ? kActiveButtonBorderColor
                  : kInactiveButtonBorderColor,
              color: categoryEnum == CategoryEnum.gym
                  ? kActiveBtnColor
                  : kInactiveBtnColor,
              textColor: categoryEnum == CategoryEnum.gym
                  ? kActiveBtnTextColor
                  : kInactiveBtnTextColor,
            ),
            SidebarButton(
              text: "trainers",
              onSelected: () {
                setState(() {
                  categoryEnum = CategoryEnum.trainers;
                });
              },
              border: categoryEnum == CategoryEnum.trainers
                  ? kActiveButtonBorderColor
                  : kInactiveButtonBorderColor,
              color: categoryEnum == CategoryEnum.trainers
                  ? kActiveBtnColor
                  : kInactiveBtnColor,
              textColor: categoryEnum == CategoryEnum.trainers
                  ? kActiveBtnTextColor
                  : kInactiveBtnTextColor,
            ),
            SidebarButton(
              text: "Style",
              onSelected: () {
                setState(() {
                  categoryEnum = CategoryEnum.style;
                });
              },
              border: categoryEnum == CategoryEnum.style
                  ? kActiveButtonBorderColor
                  : kInactiveButtonBorderColor,
              color: categoryEnum == CategoryEnum.style
                  ? kActiveBtnColor
                  : kInactiveBtnColor,
              textColor: categoryEnum == CategoryEnum.style
                  ? kActiveBtnTextColor
                  : kInactiveBtnTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
