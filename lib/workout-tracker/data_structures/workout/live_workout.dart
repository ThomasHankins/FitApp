import 'dart:async';

import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/last_workout_set_builder.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../structures.dart';
import 'adjustable_workout.dart';

class LiveWorkout extends AdjustableWorkout {
  String name;
  late final int _id;
  List<ExerciseSet> _sets;
  int _currentSetIndex = -1;

  Stopwatch workoutTimer;
  late Timer _restTimer;
  Duration _restTimeRemaining = const Duration(seconds: 0);

  int get id => _id;

  List<ExerciseSet> get sets => _sets;
  //constructors

  //state functions

  ExerciseSet? get _currentSet {
    if (_currentSetIndex < 0 || _currentSetIndex > _sets.length) return null;
    return _sets[_currentSetIndex];
  }

  int get currentSetIndex => _currentSetIndex;

  void start() async {
    workoutTimer.start();
    _id = await DatabaseManager().insertLiveWorkout(this);
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
      dbm.insertLiveWorkout(this);

      for (int i = 0; i < _sets.length; i++) {
        if (_sets[i].description.exerciseType == "strength") {
          dbm.insertHistoricStrength(_sets[i].details as StrengthDetails);
        } else if (_sets[i].description.exerciseType == "cardio") {
          dbm.insertHistoricCardio(_sets[i].details as CardioDetails);
        }
      }
    }
  }

  //set functions
  @override
  void addSet(ExerciseDescription desc, [int? position]) {
    position ??= _sets.length;
    if (position < _currentSetIndex) position = _currentSetIndex;
    _sets.insert(position,
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
    if (_sets[position].isComplete) {
      DatabaseManager().deleteSet(_sets[position]);
    }
    _sets.removeAt(position);
    //requirement that current set is between 0 and set length
    if (position < _currentSetIndex) _currentSetIndex--;
  }

  void logSet() {
    hasStarted ? start() : null;
    //requirement that current set is between 0 and set length + 1
    if (_currentSet != null) return;
    _currentSet!
        .complete(_id, workoutTimer.elapsed.inSeconds, _currentSetIndex);
    DatabaseManager().updateLiveWorkout(this);
    _currentSetIndex++;

    if (_currentSet != null) {
      _startRestTimer(_currentSet!.details.restedTime);
    }
  }

  //functions for the rest timer
  Duration get restTime => _restTimeRemaining;

  set restTime(Duration time) {
    if (!_currentSet!.isComplete) {
      _currentSet!.details.restedTime = time;
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
    _currentSet!.details.restedTime += time;
    if (_restTimeRemaining.inSeconds <= 0) {
      _startRestTimer(time);
    } else {
      _restTimeRemaining += time;
    }
  }

  set removeTime(Duration time) {
    addTime = -time;
  }

  LiveWorkout({required this.name, required List<ExerciseSet> sets})
      : _sets = sets,
        workoutTimer = Stopwatch();

  static Future<LiveWorkout> blank() async {
    //DB insert workout or something and return id
    return LiveWorkout(
      name: DateFormat.yMMMMd('en_us').format(DateTime.now()) + " - Workout",
      sets: [],
    );
  }

  static Future<LiveWorkout> fromSaved(FutureWorkout fw) async {
    //DB insert workout or something and return id

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

      ExerciseSet setToAdd = await ExerciseSet.late(
          futureDetails: lastSet(setDesc, position), description: setDesc);
      sets.add(setToAdd);
    }
    return LiveWorkout(name: fw.name, sets: sets);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': DateTime.now().toIso8601String(),
      'length': workoutTimer.elapsed.inSeconds,
    };
  }
}
