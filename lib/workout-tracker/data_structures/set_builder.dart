import '../file_manager.dart';
import 'structures.dart';

abstract class SetBuilder {
  Future<List<LiveAction>> buildSet(ExerciseDescription description);
}

class BlankSetBuilder extends SetBuilder {
  @override
  Future<List<LiveAction>> buildSet(ExerciseDescription description) {
    return [] as Future<List<LiveAction>>;
  }
}

class HistoricSetBuilder extends SetBuilder {
  @override
  Future<List<LiveAction>> buildSet(ExerciseDescription description) async {
    List<LiveSet> tempSets = [];
    List<HistoricAction> lastExercise =
        (await DatabaseManager().getExercisesFromDescription(description))
            .first
            .values
            .first
            .sets;
    for (HistoricAction action in lastExercise) {
      //obviously won't work for cardio will need to fix
      tempSets.add(LiveSet(
        weight: (action as HistoricSet).weight,
        reps: action.reps,
        restTime: action.restTime,
      ));
    }
    return tempSets;
  }
}

class LogicSetBuilder extends SetBuilder {
  @override
  Future<List<LiveSet>> buildSet(ExerciseDescription description) {
    // TODO: implement buildSet
    throw UnimplementedError();
  }
}

class PlanSetBuilder extends SetBuilder {
  @override
  Future<List<LiveSet>> buildSet(ExerciseDescription description) {
    // TODO: implement buildSet
    throw UnimplementedError();
  }
}
