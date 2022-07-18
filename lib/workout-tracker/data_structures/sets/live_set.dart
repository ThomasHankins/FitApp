import 'dart:async';

import 'details/details.dart';
import 'exercise_description.dart';
import 'exercise_set.dart';

class LiveSet extends ExerciseSet {
  //temp variables for the timer
  Timer? _countdownTimer;
  Duration _timerDurationRemaining = const Duration(seconds: 0);

  LiveSet(
      {required SetDetails details, required ExerciseDescription description})
      : super(details: details, description: description);

  void startTimer() {
    if (_timerDurationRemaining.inSeconds == 0) {
      _timerDurationRemaining = Duration(seconds: super.details.restTime);

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
      super.details.restTime = time;
      _timerDurationRemaining =
          Duration(seconds: _timerDurationRemaining.inSeconds + time);
    }
  }

  set addTime(int time) {
    super.details.restTime += time;
    _timerDurationRemaining =
        Duration(seconds: _timerDurationRemaining.inSeconds + time);
  }

  set removeTime(int time) {
    addTime = -time;
  }
}
