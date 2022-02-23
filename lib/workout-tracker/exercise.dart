class Exercise {
  //only a list of sets
  String name;
  List<ExerciseSet> sets;

  Exercise(this.name, this.sets);

  //need to rewrite

  factory Exercise.historic(
      {required String exercise, required List<dynamic> setsFile}) {
    List<ExerciseSet> tempSet = [];

    for (Map<String, dynamic> set in setsFile) {
      tempSet.add(ExerciseSet(set["weight"], set["reps"]));
    }
    return Exercise(exercise, tempSet);
  }

  bool get isDone {
    if (sets.isEmpty) {
      return false;
    }
    for (ExerciseSet set in sets) {
      if (set._complete == false) {
        return false;
      }
    }
    return true;
  }
}

class ExerciseDescription {
  String name;
  String description;
  String muscleGroup;
  ExerciseDescription(this.name, this.description, this.muscleGroup);
}

class ExerciseSet {
  int _weight;
  int _reps;
  bool _complete = false;

  ExerciseSet(this._weight, this._reps);

  set selectWeight(int weightChosen) {
    _weight = weightChosen;
  }

  int get weight {
    return _weight;
  }

  set selectReps(int repsChosen) {
    _reps = repsChosen;
  }

  get reps {
    return _reps;
  }

  void completeSet() {
    _complete = true;
  }

  bool get isComplete {
    return _complete;
  }
}
