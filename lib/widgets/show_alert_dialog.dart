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
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelBtn,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              actionBtn,
              style: const TextStyle(color: Colors.deepOrangeAccent),
            ),
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
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelBtn),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(actionBtn),
        ),
      ],
    ),
  );
}
