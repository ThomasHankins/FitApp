import 'dart:async';

import 'package:fit_app/UI/screens/saved_workouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data_structures/structures.dart';
import 'databases/dbv1.dart';

class DatabaseManager {
  //init database
  Future<Database> get _database async {
    return openDatabase(
      join(await getDatabasesPath(), 'workout_database.db'),
      onCreate: (db, version) {
        createDatabase1(db, version);
      },
      version: 1, //INITIAL VERSION
    );
  }

  void ensureInit() {
    //not sure what this does
    WidgetsFlutterBinding.ensureInitialized();
  }

  //exercise IDs
  static int? _currentExerciseDescriptionID;
  static int? _currentWorkoutID;
  static int? _currentExerciseID;
  static int? _currentSavedWorkoutID;
  static int? _currentWorkoutPlan;

  get nextExerciseDescriptionID =>
      _generateID(_currentExerciseDescriptionID, "exercise_descriptions");
  //TODO eventually add equipment lists/equipment ID
  get nextWorkoutID => _generateID(_currentWorkoutID, "workout_history");
  get nextExerciseID => _generateID(_currentExerciseID, "exercise_history");
  get nextSavedWorkoutID =>
      _generateID(_currentSavedWorkoutID, "saved_workouts");
  get nextWorkoutPlanID => _generateID(_currentWorkoutPlan, "workout_plans");

  int _generateID(int? tableID, String tableName) {
    tableID ??= () async {
      final db = await _database;
      final List<Map<String, Object?>> id = await db.rawQuery('SELECT MAX(id)'
          'FROM $tableName;');

      int? tempID = int.tryParse(id.first.values.first.toString());
      tempID ??= 0;
      return tempID;
    } as int?;
    tableID = tableID! + 1;
    return tableID;
  }

  //Inserting
  void insertExerciseDescription(ExerciseDescription ed) =>
      _insertItem(ed.toMap(), "exercise_descriptions");
  void insertHistoricWorkout(LiveWorkout workout) =>
      _insertItem(workout.toMap(), "workout_history");
  void insertHistoricExercise(LiveExercise exercise) =>
      _insertItem(exercise.toMap(), "exercise_history");
  void insertHistoricSet(LiveSet set) =>
      _insertItem(set.toMap(), "set_history");
  void insertHistoricCardio(LiveCardio cardio) =>
      _insertItem(cardio.toMap(), "cardio_history");
  void insertSavedWorkout(FutureWorkout workout) =>
      _insertItem(workout.toMap(), "saved_workouts");
  void insertSavedExercise(int workoutId, int descriptionId, int order) =>
      _insertItem({
        'workout_id': workoutId,
        "description_id": descriptionId,
        "order": order,
      }, "saved_exercises");
  void insertPlan(WorkoutPlan plan) => _insertItem(plan, "workout_plans");
  void insertPlanMap(int planId, int workoutId) => _insertItem({
        'plan_id': planId,
        'workout_id': workoutId,
      }, "plans_to_saved_workouts");
  Future<void> _insertItem(var item, String table) async {
    final db = await _database;
    await db.insert(
      table,
      item,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  //Updating
  void updateExerciseDescription(ExerciseDescription ed) =>
      _updateItem(ed, "exercise_descriptions");
  void updateSavedWorkout(FutureWorkout workout) =>
      _updateItem(workout, "saved_workouts");
  void updatePlan(WorkoutPlan plan) => _updateItem(plan, "workout_plans");

  Future<void> _updateItem(dynamic item, String table) async {
    final db = await _database;
    await db.update(table, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Deleting

  void deleteExerciseDescription(int id) =>
      _deleteItem(id, "exercise_descriptions");
  void deleteHistoricWorkout(int id) => _deleteItem(id, "workout_history");
  void deleteSavedWorkout(int id) => _deleteItem(id, "saved_workouts");
  void deletePlan(int id) => _deleteItem(id, "workout_plans");

  Future<void> _deleteItem(int id, String table) async {
    final db = await _database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Data Retrieval

  Future<ExerciseDescription> getExerciseDescription(
      Database db, int descID) async {
    List<Map<String, dynamic>> maps = await db.query(
      'exercise_descriptions',
      where: 'id = ?',
      whereArgs: [descID],
    );

    return ExerciseDescription.fromDatabase(
        id: maps[0]['id'],
        name: maps[0]['name'],
        description: maps[0]['description'],
        exerciseType: maps[0]['exercise_type']);
  }

  Future<List<ExerciseSet>> _getExerciseSets(
      Database db, int exerciseID) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'set_history',
      where: 'exercise_id = ?', //referencing the specific exercise instance
      whereArgs: [exerciseID],
    );
    return List.generate(
      maps.length,
      (index) {
        return ExerciseSet.fromDatabase(
          maps[index]['exercise_id'],
          maps[index]['position'],
          maps[index]['weight'],
          maps[index]['reps'],
          maps[index]['RPE'],
          maps[index]['note'],
          maps[index]['in_KG'],
        );
      },
    );
  }

  Future<List<ExerciseDescription>> getExerciseDescriptionList() async {
    final db = await _database;
    List<Map<String, dynamic>> maps = await db.query('exercise_descriptions');

    return Future.wait(List.generate(maps.length, (index) async {
      return ExerciseDescription.fromDatabase(
        id: maps[index]['id'],
        name: maps[index]['name'],
        description: maps[index]['description'],
        exerciseType: maps[index]['exercise_type'],
      );
    }));
  }

  // Future<ExerciseDescription> _getExerciseDescription(
  //     Database db, int descID) async {
  //   List<Map<String, dynamic>> maps = await db.query(
  //     'exercise_descriptions',
  //     where: 'id = ?',
  //     whereArgs: [descID],
  //   );
  //
  //   return ExerciseDescription.fromDatabase(
  //     id: maps[0]['id'],
  //     name: maps[0]['name'],
  //     description: maps[0]['description'],
  //     muscleGroup: maps[0]['muscle_group'],
  //     isCompound: maps[0]['is_compound'],
  //     isMachine: maps[0]['is_machine'],
  //   );
  // }

  // Future<List<Exercise>> _getExercises(Database? db, int workoutID) async {
  //   db ??= await _database;
  //   List<Map<String, dynamic>> maps = await db.query(
  //     'exercise_history',
  //     where: 'workout_id = ?',
  //     whereArgs: [workoutID],
  //   );
  //
  //   return Future.wait(List.generate(
  //     maps.length,
  //     (index) async {
  //       List<ExerciseSet> setList =
  //           await _getExerciseSets(db!, maps[index]['id']);
  //       ExerciseDescription description =
  //           await _getExerciseDescription(db, maps[index]['description_id']);
  //       return Exercise.fromDatabase(
  //         id: maps[index]['id'],
  //         workoutID: maps[index]['workout_id'],
  //         descriptionID: maps[index]['description_id'],
  //         sets: setList,
  //         exerciseDescription: description,
  //       );
  //     },
  //   ));
  // }
  //
  // Future<List<Workout>> getWorkouts() async {
  //   final db = await _database;
  //   List<Map<String, dynamic>> workoutData = await db.query('workout_history');
  //   return Future.wait(List.generate(workoutData.length, (index) async {
  //     List<Exercise> exercises =
  //         await _getExercises(db, workoutData[index]['id']);
  //     return Workout.fromHistoric(
  //         oldID: workoutData[index]['id'],
  //         oldExercises: exercises,
  //         oldName: workoutData[index]['name'],
  //         oldDate: workoutData[index]['date'],
  //         oldLength: workoutData[index]['length']);
  //   }));
  // }

  Future<List<HistoricWorkout>> getHistoricWorkouts() {
    //TODO implement method
    //basically returns a list of historic workouts
    //needs to populate exercises and sets
    throw UnimplementedError();
  }

  Future<List<SavedWorkouts>> getSavedWorkouts() {
    //TODO implement
    //returns a list of saved workouts use the fromDatabase Constructor
    throw UnimplementedError();
  }
}
