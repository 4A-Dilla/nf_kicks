import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
  BuildContext context, {
  @required String title,
  @required String description,
  String cancelBtn,
  @required String actionBtn,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <FlatButton>[
          if (cancelBtn != null)
            FlatButton(
              child: Text(
                cancelBtn,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          FlatButton(
            child: Text(
              actionBtn,
              style: TextStyle(color: Colors.deepOrangeAccent),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <CupertinoDialogAction>[
        if (cancelBtn != null)
          CupertinoDialogAction(
            child: Text(cancelBtn),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(actionBtn),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
