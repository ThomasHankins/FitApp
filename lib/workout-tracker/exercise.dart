class Exercise { //only a list of sets
  String name;
  List<ExerciseSet> sets;

  Exercise(this.name, this.sets);

  factory Exercise.makeFromProgression(Map<String, dynamic> progressionJSON, int week) {
    Map<String,dynamic> currentWeek = progressionJSON["exercises"][week];

    List<ExerciseSet> tempSet = [];
    for(int i = 0; i < currentWeek["sets"]; i ++){
      tempSet.add(ExerciseSet(progressionJSON["start weight"] + currentWeek["weightChange"], currentWeek["reps"], true, ""));
    }

    return Exercise(progressionJSON["name"], tempSet);

  }

  factory Exercise.makeFromHistoric(Map<String, dynamic> historicJSON) {
    List<ExerciseSet> tempSet = [];

    for(Map<String, dynamic> set in historicJSON["sets"]){
      tempSet.add(ExerciseSet(set["weight"], set["reps"], set["max set"], set["note"]));
    }

    return Exercise(historicJSON["name"], tempSet);
  }

}

class ExerciseDescription {
  String name;
  String description;

  ExerciseDescription(this.name, this.description);

  factory ExerciseDescription.fromJSON(Map<String, dynamic> descriptionJSON) {
    return ExerciseDescription(
        descriptionJSON['name'], descriptionJSON['description']);
  }
}

class ExerciseSet {
  int _weight;
  int _reps;
  bool _isMaxExerciseSet;
  String _note = "";
  bool _complete = false;

  ExerciseSet(this._weight, this._reps, this._isMaxExerciseSet, this._note);

  void exerciseSetWeight(int weightChosen) {
    _weight = weightChosen;
  }

  int getWeight() {
    return _weight;
  }

  void exerciseSetReps(int repsChosen) {
    _reps = repsChosen;
  }

  int getReps() {
    return _reps;
  }

  void toggleIsMaxExerciseSet() {
    _isMaxExerciseSet = !_isMaxExerciseSet;
  }

  bool getIsMaxExerciseSet() {
    return _isMaxExerciseSet;
  }

  void addNote(String addedNote) {
    _note = addedNote;
  }

  String getNote() {
    return _note;
  }

  void completeSet(){
    _complete = true;
  }

  bool isComplete(){
    return _complete;
  }


}
