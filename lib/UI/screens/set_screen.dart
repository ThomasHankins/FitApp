import 'package:fit_app/UI/components/rounded_button.dart';
import 'package:flutter/material.dart';

class WorkoutSelect extends StatefulWidget {
  static String id = 'workout_select';

  @override
  _WorkoutSelectState createState() => _WorkoutSelectState();
}

class _WorkoutSelectState extends State<WorkoutSelect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    text: "Do Today's Workout",
                    colour: Colors.blue,
                    onPressed: null,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    text: "Custom Workout",
                    colour: Colors.blue,
                    onPressed: null,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    text: "Select Plan",
                    colour: Colors.blue,
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
