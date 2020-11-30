import 'package:flutter/material.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/widgets/background_stack.dart';

class Loading extends StatelessWidget {
  final Widget loadingWidget;

  Loading({@required this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backgroundStack(loadingWidget),
    );
  }
}
