// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:nf_kicks/widgets/background_stack.dart';

class Loading extends StatelessWidget {
  final Widget loadingWidget;

  const Loading({@required this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backgroundStack(loadingWidget),
    );
  }
}
