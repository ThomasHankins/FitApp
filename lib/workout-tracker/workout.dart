import 'dart:async';
import 'dart:convert' show json;

import 'package:intl/intl.dart';

import 'exercise.dart';
import 'file_manager.dart';

class Workout {
  int? _id;
  String name;
  List<Exercise> exercises;
  DateTime date;
  Stopwatch? timer; //init  Stopwatch() later
  int length = 0;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': name,
      'date': date.toIso8601String(),
      'length': length,
    };
  }

  @override
  String toString() {
    //can remove later if necessary
    return 'Workout{id: $_id, name: $name, date: $date.toIso8601String(), length: $length)';
  }

  Workout(
      {required this.name,
      required this.exercises,
      required this.date,
      required this.length});

  Future<void> generateID() async {
    if (_id is int) {
      _id = (await DatabaseManager().generateWorkoutID())!;
    }
    int? availableID = await DatabaseManager().;
    availableID = (availableID is! int) ? 1 : availableID;
    for (Exercise exercise in exercises) {
      exercise.giveID = availableID!;
      availableID++;
    }
  }

  //DateTime.now().toIso8601String() add this to blank workout constructor
  Workout.fromHistoric(
      int oldID, String oldName, String oldDate, int oldLength) {
    _id = oldID;
    exercises = [];
    name = oldName;
    date = DateTime.parse(oldDate);
    length = oldLength;
  }

  static Future<Workout> fromEmpty() async {
    DateFormat formater = DateFormat.yMMMMd('en_us');
    return Workout(formater.format(DateTime.now()) + " - Workout", []);
  }

  static Future<Workout> fromSaved(int planID) async {
    Map<String, dynamic> plan = json
        .decode(await FileManager().readFile('plans'))
        .firstWhere((element) => element["plan id"] == planID);

    List<dynamic> exercisesFile =
        json.decode(await FileManager().readFile('exercises'));

    List<Exercise> exercisesList = [];
    for (String exerciseName in plan["exercises"]) {
      exercisesList.add(
        Exercise.historic(
            exercise: exerciseName.toString(),
            setsFile: exercisesFile
                .firstWhere((element) => element["name"] == exerciseName)[
                    "previous efforts"]
                .last["sets"]),
      );
    }
    return Workout(plan["name"], exercisesList);
  }

  Future<void> saveWorkout(int? id) async {
    //parse plans file
    List<dynamic> plansJSON =
        json.decode(await FileManager().readFile('plans'));

    //save exercise names
    List<String> exerciseNames = [];
    for (Exercise exercise in exercises) {
      exerciseNames.add(exercise.name);
    }
    //get plan id
    int planID;
    if (id == null) {
      planID = plansJSON.last["plan id"] + 1;
    } else {
      planID = id;
      plansJSON.removeWhere((element) => element["plan id"] == id);
    }

    //save JSON file
    if (exerciseNames.isNotEmpty) {
      plansJSON.add({
        "name": name,
        "plan id": planID,
        "hidden": false,
        "exercises": exerciseNames
      });
      FileManager().writeFile('plans', json.encode(plansJSON));
    }
  }

  Future<void> endWorkout() async {
    for (Exercise exercise in exercises) {
      exercise.sets.removeWhere((element) => !element.isComplete);
    }

    exercises.removeWhere((element) => element.sets.isEmpty);
    timer?.stop();
    length = timer?.elapsed;
    if (exercises.isNotEmpty) {
      DatabaseManager().insertWorkout(this);
    }
  }
}
