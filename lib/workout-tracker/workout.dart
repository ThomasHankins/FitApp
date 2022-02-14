import 'dart:convert' show json;
import 'dart:io' show File;
import 'HistoryManager.dart';
import 'package:intl/intl.dart';

import 'exercise.dart';

class Workout {
  String name;
  String? planName;
  File? plans;
  List<Exercise> exercises;
  var date = DateTime.now();
  int length = 0;

  Workout(this.name, this.exercises, this.planName, this.plans);

  factory Workout.fromPlan(String plan, File workoutPlans) {
    List<dynamic> workoutPlansJSON =
        json.decode(workoutPlans.readAsStringSync());

    Map<String, dynamic> thisPlan = workoutPlansJSON[0];

    for (Map<String, dynamic> testPlan in workoutPlansJSON) {
      if (testPlan["name"] == plan) {
        thisPlan = testPlan;
        break;
      }
    }

    int cycleWeek = thisPlan[plan]['current week'];
    int cycleDay = thisPlan[plan]['current day'];
    List<Exercise> tempExercises = [];

    for (Map<String, dynamic> exercise in thisPlan['workout days'][cycleDay]
        ['exercises']) {
      tempExercises.add(Exercise.makeFromProgression(exercise, cycleWeek));
    }

    return Workout(thisPlan['workout days'][cycleDay]["name"], tempExercises,
        plan, workoutPlans);
  }

  factory Workout.fromJSON(Map<String, dynamic> jsonString){
    List<Exercise> exercisesList = [];
    for(Map<String, dynamic> i in jsonString["exercises"]){
      exercisesList.add(Exercise.makeFromHistoric(i));
    }

    return Workout(jsonString["name"], exercisesList, null, null);
  }


  factory Workout.fromEmpty() {
    DateFormat formater = DateFormat.yMMMMd('en_us');
    return Workout(
        formater.format(DateTime.now()) + " Workout", [], null, null);
  }

  Future<void> endWorkout() async {


    if (plans != null) {
      List<dynamic> planJSON = json.decode(plans!.readAsStringSync());

      //adjust the plan length
      Map<String, dynamic> thisPlan = planJSON[0];

      for (Map<String, dynamic> testPlan in planJSON) {
        if (testPlan["name"] == planName) {
          thisPlan = testPlan;
          break;
        }
      }

      int workoutWeekLength = thisPlan["workoutDays"].length;

      if (workoutWeekLength <= thisPlan["currentDay"]) {
        thisPlan["currentDay"] = 0;
        thisPlan["currentWeek"] += 1;
      } else {
        thisPlan["currentDay"] += 1;
      }
      plans?.writeAsStringSync(json.encode(planJSON));
    }

    //save the plan to history
    HistoryManager history = HistoryManager();
    List<dynamic> historyJSON = json.decode(await history.readHistory());

    List<dynamic> exercisesJSON = [];

    for (Exercise exercise in exercises) {
      List<dynamic> setJSON = [];
      for (ExerciseSet set in exercise.sets) {
        if (set.isComplete()) {
          setJSON.add({
            "reps": set.getReps(),
            "weight": set.getWeight(),
            "note": set.getNote(),
            "max set": set.getIsMaxExerciseSet()
          });
        }
      }
      exercisesJSON.add({"name": exercise.name, "sets": setJSON});
    }

    Map<String, dynamic> thisWorkout = {
      "name": name,
      "day": date.day,
      "month": date.month,
      "year": date.year,
      "length": length,
      "exercises": exercisesJSON
    };
    historyJSON.add(thisWorkout);

    history.writeHistory(json.encode(historyJSON));
  }
}
