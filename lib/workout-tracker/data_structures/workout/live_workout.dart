import 'dart:async';

import 'package:fit_app/workout-tracker/data_structures/sets/details/details_cardio.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/details_strength.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/last_workout_set_builder.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../structures.dart';
import 'adjustable_workout.dart';
import 'future_workout.dart';

class LiveWorkout extends AdjustableWorkout {
  String name;
  int _id;
  List<ExerciseSet> _sets;
  int _currentSetIndex = -1;

  Stopwatch workoutTimer;
  late Timer _restTimer;
  Duration _restTimeRemaining = const Duration(seconds: 0);

  //constructors

  //state functions

  ExerciseSet? get _currentSet {
    if (_currentSetIndex < 0 || _currentSetIndex > _sets.length) return null;
    return _sets[_currentSetIndex];
  }

  void start() {
    workoutTimer.start();
  }

  bool get hasStarted {
    if (_sets.isEmpty) return false;
    for (ExerciseSet set in _sets) {
      if (set.isComplete) return true;
    }
    return false;
  }

  Future<void> endWorkout() async {
    workoutTimer.stop();

    _sets.removeWhere((element) => !element.isComplete);

    if (_sets.isNotEmpty) {
      DatabaseManager dbm = DatabaseManager();
      dbm.insertHistoricWorkout(this);

      for (int i = 0; i < _sets.length; i++) {
        if (_sets[i].description.exerciseType == "strength") {
          dbm.insertHistoricSet(_sets[i].details as StrengthDetails);
        } else if (_sets[i].description.exerciseType == "cardio") {
          dbm.insertHistoricCardio(_sets[i].details as CardioDetails);
        }
      }
    }
  }

  //set functions
  @override
  void addSet(ExerciseDescription desc, [int? position]) {
    //requirement that position is after or equal to current set
    if (position! < _currentSetIndex) position = _currentSetIndex;
    _sets.insert(position ?? _sets.length,
        ExerciseSet(description: desc, details: SetDetails.blank(desc)));
  }

  //functions for adding and reordering
  @override
  void reorderSet(int oldPosition, int newPosition) {
    if (!_sets[oldPosition].isComplete && !_sets[newPosition].isComplete) {
      _sets.insert(newPosition, _sets.removeAt(oldPosition));
    }
  }

  @override
  void deleteSet(int position) {
    _sets.removeAt(position);
    //requirement that current set is between 0 and set length
    if (position < _currentSetIndex) _currentSetIndex--;
  }

  void logSet() {
    //requirement that current set is between 0 and set length + 1
    if (_currentSet != null) return;
    _sets[_currentSetIndex].complete();
    _currentSetIndex++;

    if (_currentSet != null) {
      _startRestTimer(_currentSet?.details.restTime);
    }
  }

  //functions for the workout timer

  //functions for the rest timer
  Duration get restTime => _restTimeRemaining;

  set restTime(Duration time) {
    if (!_currentSet!.isComplete) {
      _currentSet!.details.restTime = time;
      _restTimeRemaining += time;
    }
  }

  void _startRestTimer(Duration time) {
    //called by logset and addTime
    if (_restTimeRemaining.inSeconds <= 0) {
      _restTimeRemaining = time;

      _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_restTimeRemaining <= const Duration(seconds: 0)) {
          _restTimer.cancel();
        } else {
          _restTimeRemaining -= const Duration(seconds: 1);
        }
      });
    }
  }

  set addTime(Duration time) {
    _currentSet!.details.restTime += time;
    if (_restTimeRemaining.inSeconds <= 0) {
      _startRestTimer(time);
    } else {
      _restTimeRemaining += time;
    }
  }

  set removeTime(Duration time) {
    addTime = -time;
  }

  LiveWorkout(
      {required this.name, required int id, required List<ExerciseSet> sets})
      : _id = id,
        _sets = sets,
        workoutTimer = Stopwatch();

  static Future<LiveWorkout> blank() async {
    int id = await DatabaseManager().nextWorkoutID;
    return LiveWorkout(
      name: DateFormat.yMMMMd('en_us').format(DateTime.now()) + " - Workout",
      id: id,
      sets: [],
    );
  }

  static Future<LiveWorkout> fromSaved(FutureWorkout fw) async {
    int id = await DatabaseManager().nextWorkoutID;
    List<ExerciseSet> sets = [];
    Map<ExerciseDescription, int> _exercises =
        {}; //used to map how many sets are at each exercise desc
    for (ExerciseDescription setDesc in fw.sets) {
      int position = 0;
      if (_exercises.containsKey(setDesc)) {
        _exercises.update(setDesc, (value) => value++);
        position = _exercises[setDesc] ?? 0;
      } else {
        _exercises.addEntries([MapEntry(setDesc, 0)]);
      }
      sets.add(ExerciseSet(
          details: lastSet(setDesc, position),
          description:
              setDesc)); //in the future I would like this to have different options in the settings screen
    }
    return LiveWorkout(id: id, name: fw.name, sets: sets);
  }

  @override
  Map<String, dynamic> toMap() {
    //TODO verify correctness
    return {
      'name': name,
      'date': DateTime.now().toIso8601String(),
      'length': workoutTimer.elapsed.inSeconds,
    };
  }

  //TODO save workout on creation and after every update (addSet/deleteSet/rearrangeSet/logSet)
}
