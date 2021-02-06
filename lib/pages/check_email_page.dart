import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/utils/common_functions.dart';
import 'package:nf_kicks/widgets/background_stack.dart';
import 'package:nf_kicks/widgets/floating_action_button.dart';

import '../widgets/constants.dart';

class CheckEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: nfKicksFloatingActionButton(
        fabButtonOnPress: () => CommonFunctions.logOut(context),
        fabIcon: Icon(Icons.login),
      ),
      body: backgroundStack(kLogoCheckEmail),
    );
  }
}
