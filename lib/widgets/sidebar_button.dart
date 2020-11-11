import 'package:flutter/material.dart';

class SidebarButton extends StatelessWidget {
  SidebarButton(
      {@required this.text,
      this.onSelected,
      this.border,
      this.color,
      this.textColor});

  final String text;
  final Function onSelected;
  final RoundedRectangleBorder border;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: border,
      color: color,
      onPressed: onSelected,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
        child: Text(
          text.toLowerCase(),
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
    );
  }
}
