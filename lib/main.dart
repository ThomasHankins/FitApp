import 'package:flutter/material.dart';

import 'UI/components/themes.dart';
import 'UI/screens/dashboard.dart';

void main() {
  runApp(const FitApp());
}

class FitApp extends StatelessWidget {
  const FitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Fit App",
        darkTheme: AppThemes().dark(),
        themeMode: ThemeMode.dark,
        home: const Dashboard(),
        debugShowCheckedModeBanner: false);
  }
}
