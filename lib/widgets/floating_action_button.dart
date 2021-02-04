import 'package:flutter/material.dart';
import 'package:nf_kicks/widgets/constants.dart';

FloatingActionButton nfKicksFloatingActionButton({
  Function fabButtonOnPress,
  Icon fabIcon,
  Color fabColor = kPrimaryColor,
}) {
  return FloatingActionButton(
    onPressed: fabButtonOnPress,
    child: fabIcon,
    backgroundColor: fabColor,
  );
}
