// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:nf_kicks/widgets/constants.dart';

FloatingActionButton nfKicksFloatingActionButton({
  void Function() fabButtonOnPress,
  Icon fabIcon,
  Color fabColor = kPrimaryColor,
}) {
  return FloatingActionButton(
    onPressed: fabButtonOnPress,
    backgroundColor: fabColor,
    child: fabIcon,
  );
}
