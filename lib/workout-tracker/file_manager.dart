import 'dart:async';

import 'package:fit_app/workout-tracker/db_transactions/add_exercises.dart';
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
        addExercises(db);
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

  Future<int> get nextExerciseDescriptionID async =>
      await _generateID(_currentExerciseDescriptionID, "exercise_descriptions");
  //TODO eventually add equipment lists/equipment ID
  Future<int> get nextWorkoutID async =>
      await _generateID(_currentWorkoutID, "workout_history");
  Future<int> get nextExerciseID async =>
      await _generateID(_currentExerciseID, "exercise_history");
  Future<int> get nextSavedWorkoutID async =>
      await _generateID(_currentSavedWorkoutID, "saved_workouts");
  Future<int> get nextWorkoutPlanID async =>
      await _generateID(_currentWorkoutPlan, "workout_plans");

  Future<int> _generateID(int? tableID, String tableName) async {
    Future<int> getID() async {
      final db = await _database;
      final List<Map<String, Object?>> id = await db.rawQuery('SELECT MAX(id)'
          'FROM $tableName;');

      int? tempID = int.tryParse(id.first.values.first.toString());
      tempID ??= 0;
      return tempID;
    }

    tableID ??= await getID();
    tableID++;
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

  Future<List<HistoricSet>> _getHistoricSets(
      Database db, int workoutID, int exercisePosition) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'set_history',
      where:
          'workout_id = ? AND exercise_position = ?', //referencing the specific exercise instance
      whereArgs: [workoutID, exercisePosition],
    );
    return List.generate(
      maps.length,
      (index) {
        return HistoricSet(
          weight: maps[index]['weight'],
          reps: maps[index]['reps'],
          note: maps[index]['note'],
          position: maps[index]['position'],
          rpe: maps[index]['RPE'],
          restTime: maps[index]['rest_time'],
        );
      },
    );
  }

  Future<List<HistoricCardio>> _getHistoricCardio(
      Database db, int workoutID, int exercisePosition) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'cardio_history',
      where:
          'workout_id = ? AND exercise_position = ?', //referencing the specific exercise instance
      whereArgs: [workoutID, exercisePosition],
    );
    return List.generate(
      maps.length,
      (index) {
        return HistoricCardio(
          note: maps[index]['note'],
          position: maps[index]['position'],
          calories: maps[index]['calories'],
          distance: maps[index]['distance'],
          restTime: maps[index]['rest_time'],
          length: maps[index]['length'],
        );
      },
    );
  }

  Future<List<HistoricExercise>> _getExercises(
      Database? db, int workoutID) async {
    db ??= await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'exercise_history',
      where: 'workout_id = ?',
      whereArgs: [workoutID],
    );

    return Future.wait(List.generate(
      maps.length,
      (index) async {
        List<HistoricSet> setList = await _getHistoricSets(
            db!, maps[index]['id'], maps[index]['position']);
        List<HistoricCardio> cardioList = await _getHistoricCardio(
            db, maps[index]['id'], maps[index]['position']);
        ExerciseDescription description =
            await getExerciseDescription(db, maps[index]['description_id']);
        return HistoricExercise(
          position: maps[index]['position'],
          description: description,
          sets: setList.isNotEmpty ? setList : cardioList,
        );
      },
    ));
  }

  Future<List<HistoricWorkout>> getHistoricWorkouts() async {
    final db = await _database;
    List<Map<String, dynamic>> workoutData = await db.query('workout_history');
    return Future.wait(List.generate(workoutData.length, (index) async {
      List<HistoricExercise> exercises =
          await _getExercises(db, workoutData[index]['id']);
      return HistoricWorkout(
          id: workoutData[index]['id'],
          exercises: exercises,
          name: workoutData[index]['name'],
          date: workoutData[index]['date'],
          length: workoutData[index]['length']);
    }));
  }

  Future<List<FutureWorkout>> getSavedWorkouts() {
    //TODO implement
    //returns a list of saved workouts use the fromDatabase Constructor
    throw UnimplementedError();
  }
}
