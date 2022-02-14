import 'package:flutter/material.dart';

import '../../workout-tracker/workout.dart';

import '../components/exercise_history_widget.dart';

class HistoryDetailScreen extends StatefulWidget {
  final Workout thisWorkout;

  HistoryDetailScreen({required this.thisWorkout});

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.thisWorkout.exercises.length,
                itemBuilder: (context, i) {
                  return ExerciseHistoryWidget(
                   thisExercise: widget.thisWorkout.exercises[i],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
