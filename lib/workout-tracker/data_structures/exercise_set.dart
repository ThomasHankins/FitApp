import 'dart:async';

abstract class Action {
  late int _position;
  int get position => _position;

  int _restTime; //TODO refactor to make type duration
  int get restTime => _restTime;

  String _note;
  String get note => _note;

  Action({required restTime, required note})
      : _restTime = restTime,
        _note = note;
}

abstract class LiveAction extends Action {
  late int _parentPosition;
  late int _workoutID;

  //temp variables for the timer
  Timer? _countdownTimer;
  Duration _timerDurationRemaining = const Duration(seconds: 0);

  bool _complete = false;
  bool get isComplete => _complete;

  void complete(int position, int parentPosition, int workoutID) {
    _complete = true;
    _position = position;
    _parentPosition = parentPosition;
    _workoutID = workoutID;
    _countdownTimer?.cancel();
  }

  Map<String, dynamic> toMap();

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

  int get restTimeLeft => _timerDurationRemaining.inSeconds;

  set restTime(int time) {
    if (!isComplete) {
      _restTime = time;
      _timerDurationRemaining =
          Duration(seconds: _timerDurationRemaining.inSeconds + time);
    }
  }

  set addTime(int time) {
    _restTime += time;
    _timerDurationRemaining =
        Duration(seconds: _timerDurationRemaining.inSeconds + time);
  }

  set removeTime(int time) {
    addTime = -time;
  }

  set note(String note) =>
      note.length < 30 ? _note = note : _note = note.substring(0, 30);

  LiveAction({
    required restTime,
    required note,
  }) : super(
          restTime: restTime,
          note: note,
        );
}

abstract class HistoricAction extends Action {
  HistoricAction({
    required position,
    required restTime,
    required note,
  }) : super(
          restTime: restTime,
          note: note,
        ) {
    _position = position;
  }
}

mixin Strength on Action {
  late double _weight;
  double get weight => _weight;

  late int _reps;
  int get reps => _reps;

  int? _rpe;
  int? get rpe => _rpe;
}

mixin Cardio on Action {
  late int _duration;
  int get duration => _duration;

  late int _distance;
  int get distance => _distance;

  int? _calories;
  int? get calories => _calories;
}

class LiveSet extends LiveAction with Strength {
  LiveSet({required double weight, required int reps, required int restTime})
      : super(restTime: restTime, note: "") {
    _weight = weight;
    _reps = reps;
  }

  set weight(double weight) => _weight = weight;
  set reps(int reps) => _reps = reps;
  set rpe(int? rpe) => (rpe! >= 0 || rpe <= 10) ? _rpe = rpe : null;

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
  void complete(int position, int parentPosition, int workoutID) {
    if (reps > 0) {
      super.complete(position, parentPosition, workoutID);
    } else {
      super._countdownTimer?.cancel();
    }
  }
}

class LiveCardio extends LiveAction with Cardio {
  LiveCardio(
      {required int distance, required int duration, required int restTime})
      : super(restTime: restTime, note: "") {
    _distance = distance;
    _duration = duration;
  }

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
  void complete(int position, int parentPosition, int workoutID) {
    if (distance > 0 && duration > 0) {
      _complete = true;
      _position = position;
      _parentPosition = parentPosition;
      _workoutID = workoutID;
    }
  }
}

class HistoricSet extends HistoricAction with Strength {
  HistoricSet({
    required int position,
    required double weight,
    required int reps,
    required int restTime,
    required int? rpe,
    required String note,
  }) : super(
          position: position,
          note: note,
          restTime: restTime,
        ) {
    _weight = weight;
    _reps = reps;
    _rpe = rpe;
  }
}

class HistoricCardio extends HistoricAction with Cardio {
  HistoricCardio({
    required int position,
    required int duration,
    required int distance,
    required int restTime,
    required int? calories,
    required String note,
  }) : super(
          position: position,
          note: note,
          restTime: restTime,
        ) {
    _duration = duration;
    _distance = distance;
    _calories = calories;
  }
}
