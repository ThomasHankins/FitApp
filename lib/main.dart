import 'package:flutter/material.dart';

// import 'workout-tracker/Exercise.dart';
import 'UI/screens/welcome_screen.dart';
import 'UI/screens/workout_screen.dart';
import 'UI/screens/workout_select.dart';

void main() {
  runApp(const FitApp());
}

class FitApp extends StatelessWidget {
  const FitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        WorkoutSelect.id: (context) => WorkoutSelect(),
        WorkoutScreen.id: (context) => WorkoutScreen(),
      },
    );
  }
}
