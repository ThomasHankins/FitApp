import 'package:fit_app/UI/screens/exercise_description_screen/exercise_description_components/description_history_widget.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import '../../../workout-tracker/database/database.dart';

class ExerciseDescriptionScreen extends StatefulWidget {
  final ExerciseDescription thisExercise;

  const ExerciseDescriptionScreen({Key? key, required this.thisExercise})
      : super(key: key);

  @override
  _ExerciseDescriptionScreenState createState() =>
      _ExerciseDescriptionScreenState();
}

class _ExerciseDescriptionScreenState extends State<ExerciseDescriptionScreen> {
  bool loaded = false;
  late ExerciseDescription thisExercise;
  late List<Map<DateTime, ExerciseSet>> history;

  Future<void> loadExercise() async {
    thisExercise = widget.thisExercise;
    history = await DatabaseManager().getSetsFromDescription(thisExercise);
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadExercise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: loaded ? Text(thisExercise.name) : null,
      ),
      body: loaded
          ? DescriptionHistoryContainer(history: history)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
