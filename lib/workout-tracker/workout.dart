import 'dart:convert' show json;

import 'package:intl/intl.dart';

import 'FileManager.dart';
import 'exercise.dart';

class Workout {
  String name;
  List<Exercise> exercises;
  var date = DateTime.now();
  int length = 0;

  Workout(this.name, this.exercises);

  static Future<Workout> fromHistoric(
      int workoutID, String workoutName, List<dynamic> exerciseNames) async {
    //exercise files
    List<dynamic> exercisesFile =
        json.decode(await FileManager().readFile('exercises'));
    //loads first instance in workout file with matching workout id

    List<Exercise> exercisesList = [];

    for (dynamic exerciseName in exerciseNames) {
      exercisesList.add(
        Exercise.historic(
            exercise: exerciseName.toString(),
            setsFile: exercisesFile
                .firstWhere((element) =>
                    element["name"] ==
                    exerciseName.toString())["previous efforts"]
                .firstWhere(
                    (element) => element["workout id"] == workoutID)["sets"]),
      );
    }
    return Workout(workoutName, exercisesList);
  }

  static Future<Workout> fromEmpty() async {
    DateFormat formater = DateFormat.yMMMMd('en_us');
    return Workout(formater.format(DateTime.now()) + " Workout", []);
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
    //TODO Implement from saved factory
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
    //save the plan to history and exercises
    //TODO only save exercises with sets & non empty workouts
    //parse workoutHistory JSON
    List<dynamic> historyJSON =
        json.decode(await FileManager().readFile('history'));

    //determine workout ID and create a list of exercise names
    int workoutID = historyJSON.last["workout id"] + 1;
    List<String> exerciseNames = [];
    for (Exercise exercise in exercises) {
      exerciseNames.add(exercise.name);
    }
    //turn data into a Map
    Map<String, dynamic> thisWorkout = {
      "name": name,
      "workout id": workoutID,
      "date": "${date.day}/${date.month}/${date.year}",
      "length": length,
      "exercises": exerciseNames
    };

    //add data to decoded JSON
    historyJSON.add(thisWorkout);

    //write data to JSON
    FileManager().writeFile('history', json.encode(historyJSON));

    //decode exercise list
    List<dynamic> exercisesJSON =
        json.decode(await FileManager().readFile('exercises'));

    for (Exercise exercise in exercises) {
      //create a list of dynamic containing weight and reps
      List<dynamic> sets = [];
      for (ExerciseSet set in exercise.sets) {
        if (set.isComplete) {
          sets.add({"weight": set.weight, "reps": set.reps});
        }
      }
      //adding sets to matching exercise
      exercisesJSON
          .firstWhere(
              (element) => element["name"] == exercise.name)["previous efforts"]
          .add(
        {"workout id": workoutID, "sets": sets},
      );
    }
    FileManager().writeFile('exercises', json.encode(exercisesJSON));
  }
}
