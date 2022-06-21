import 'package:beatscode_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    /* One time with the user provider class */
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    /// Builder function which will return to us a context and constraints(responsive)
    return LayoutBuilder(builder: (context, constraints) {
      // if this limit pass I will have a web screen layout
      if (constraints.maxWidth > webScreenSize) {
        // web screen
        return widget.webScreenLayout;
      }
      // mobile screen
      return widget.mobileScreenLayout;
    });
  }
}
