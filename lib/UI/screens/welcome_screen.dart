import 'package:fit_app/UI/components/rounded_button.dart';
import 'package:flutter/material.dart';

import 'workout_select.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                    text: 'Work Out',
                    colour: Colors.blue,
                    onPressed: () {
                      Navigator.pushNamed(context, WorkoutSelect.id);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
