import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  final Function setState;
  const DashboardWidget({Key? key, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[], //TODO Add dashboard content here
      ),
    );
  }
}
