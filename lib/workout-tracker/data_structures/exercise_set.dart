import 'dart:async';

abstract class LiveAction {
  bool get isComplete;
  set note(String note);
  set restTime(int restTime);
  String get note;
  Map<String, dynamic> toMap();
  void complete(int position, int parentPosition, int workoutID);
  int get restTimeLeft;
  set addTime(int time);
  set removeTime(int time);
  void startTimer();
}

abstract class HistoricAction {
  int get position;
}

mixin ExerciseSet {
  double get weight;
  int get reps;
  int get restTime;
  int? get rpe;
  String get note;
}

mixin Cardio {
  int get duration;
  int get distance;
  int get restTime;
  int? get calories;
  String get note;
}

class LiveSet extends LiveAction with ExerciseSet {
  @override
  double weight;
  @override
  int reps;
  @override
  int restTime;
  @override
  int? rpe;
  String _note = '';
  late int _parentPosition;
  late int _position;
  late int _workoutID;
  bool _complete = false;
  //temp variables for the timer
  Timer? _countdownTimer;
  Duration _timerDurationRemaining = const Duration(seconds: 0);

  LiveSet({required this.weight, required this.reps, required this.restTime});

  @override
  Map<String, dynamic> toMap() {
    return {
      'workout_id': _workoutID,
      'exercise_position': _parentPosition,
      'position': _position,
      'weight': weight,
      'reps': reps,
      'rest_time': restTime,
      'RPE': rpe,
      'note': _note,
    };
  }

  @override
  bool get isComplete => _complete;

  @override
  String get note => _note;
  @override
  set note(String note) =>
      note.length < 30 ? _note = note : _note = note.substring(0, 30);

  @override
  void complete(int position, int parentPosition, int workoutID) {
    if (reps > 0) {
      _complete = true;
      _position = position;
      _parentPosition = parentPosition;
      _workoutID = workoutID;
    }
    _countdownTimer?.cancel();
  }

  @override
  void startTimer() {
    if (_timerDurationRemaining.inSeconds == 0) {
      _timerDurationRemaining = Duration(seconds: restTime);

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerDurationRemaining <= const Duration(seconds: 0)) {
          _countdownTimer!.cancel();
        } else {
          _timerDurationRemaining -= const Duration(seconds: 1);
        }
      });
    }
  }

  @override
  int get restTimeLeft => _timerDurationRemaining.inSeconds;

  @override
  set addTime(int time) {
    restTime += time;
    _timerDurationRemaining =
        Duration(seconds: _timerDurationRemaining.inSeconds + time);
  }

  @override
  set removeTime(int time) {
    restTime -= time;
    _timerDurationRemaining =
        Duration(seconds: _timerDurationRemaining.inSeconds - time);
  }
}

class LiveCardio extends LiveAction with Cardio {
  @override
  int duration;
  @override
  int distance;
  @override
  int restTime;
  @override
  int? calories;
  String _note = '';
  late int _parentPosition;
  late int _position;
  late int _workoutID;
  bool _complete = false;

  LiveCardio(
      {required this.duration, required this.distance, required this.restTime});

  @override
  Map<String, dynamic> toMap() {
    return {
      'workout_id': _workoutID,
      'exercise_position': _parentPosition,
      'position': _position,
      'length': duration,
      'distance': distance,
      'rest_time': restTime,
      'calories': calories,
      'note': _note,
    };
  }

  @override
  bool get isComplete => _complete;

  @override
  String get note => _note;
  @override
  set note(String note) =>
      note.length < 30 ? _note = note : _note = note.substring(0, 30);

  @override
  void complete(int position, int parentPosition, int workoutID) {
    if (distance > 0 && duration > 0) {
      _complete = true;
      _position = position;
      _parentPosition = parentPosition;
      _workoutID = workoutID;
    }
  }

  @override
  // TODO: implement restTimeLeft
  int get restTimeLeft => throw UnimplementedError();

  @override
  set addTime(int time) {
    // TODO: implement addTime
  }

  @override
  set removeTime(int time) {
    // TODO: implement removeTime
  }

  @override
  void startTimer() {
    // TODO: implement startTimer
  }
}

class HistoricSet extends HistoricAction with ExerciseSet {
  final int _position;
  final double _weight;
  final int _reps;
  final int _restTime;
  final int? _rpe;
  final String _note;

  HistoricSet({
    required int position,
    required double weight,
    required int reps,
    required int restTime,
    required int? rpe,
    required String note,
  })  : _position = position,
        _weight = weight,
        _reps = reps,
        _restTime = restTime,
        _rpe = rpe,
        _note = note;

  @override
  int get position => _position;

  @override
  double get weight => _weight;

  @override
  int get reps => _reps;

  @override
  int get restTime => _restTime;

  @override
  int? get rpe => _rpe;

  @override
  String get note => _note;
}

class HistoricCardio extends HistoricAction with Cardio {
  final int _position;
  final int _duration;
  final int _distance;
  final int _restTime;
  final int? _calories;
  final String _note;

  HistoricCardio({
    required int position,
    required int duration,
    required int distance,
    required int restTime,
    required int? calories,
    required String note,
  })  : _position = position,
        _duration = duration,
        _distance = distance,
        _restTime = restTime,
        _calories = calories,
        _note = note;

  @override
  int get position => _position;

  @override
  int get duration => _duration;

  @override
  int get distance => _distance;

  @override
  int get restTime => _restTime;

  @override
  int? get calories => _calories;

  @override
  String get note => _note;
}
