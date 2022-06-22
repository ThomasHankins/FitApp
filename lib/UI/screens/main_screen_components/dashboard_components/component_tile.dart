import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dashboard_ui.dart';

class ComponentTile extends StatelessWidget {
  ComponentTile({Key? key, required this.widget, required this.child})
      : super(key: key);

  Widget child;
  final DashboardWidget widget;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: child);
  }
}
