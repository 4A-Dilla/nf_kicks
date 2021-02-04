import 'package:flutter/material.dart';
import 'package:nf_kicks/widgets/background_stack.dart';

import '../widgets/constants.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backgroundStack(kLogoError),
    );
  }
}
