import 'dart:async';

import 'package:fit_app/workout-tracker/data_structures/sets/details/details_cardio.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/details_strength.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/future_workout.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/live_workout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data_structures/structures.dart';
import 'database_versions/dbv1.dart';
import 'database_versions/dbv2.dart';
import 'db_transactions/add_exercises.dart';

class DatabaseManager {
  Future<List<Map<String, dynamic>>> testFunc() async {
    final db = await _database;
    return await db.query(
      'saved_exercises',
    );
  }

  //init database
  static Future<Database> get _database async {
    return openDatabase(
      join(await getDatabasesPath(), 'workout_database.db'),
      onCreate: (db, version) {
        createDatabase2(db, version);
        addExercises(db);
      },
      onOpen: (db) => db.execute("PRAGMA foreign_keys=ON"),
      onUpgrade: (db, v1, v2) =>
          throw UnimplementedError("Implement DB Update"),
      version: 2,
      singleInstance: true, //is true by default, just specifying this
    );
  }

  void ensureInit() {
    //not sure what this does
    WidgetsFlutterBinding.ensureInitialized();
  }

  //Inserting
  //TODO ensure that the map has been inserted for each of these below
  void insertExerciseDescription(ExerciseDescription ed) =>
      _insertItem(ed.toMap(), "exercise_descriptions");
  void insertHistoricWorkout(LiveWorkout workout) =>
      _insertItem(workout.toMap(), "workout_history");
  //TODO figure out how to get id for the next three if we use autoincrement
  void insertHistoricSet(ExerciseSet set) =>
      _insertItem(set.toMap(), "set_history");
  void insertHistoricStrength(StrengthDetails set) =>
      _insertItem(set.toMap(), "strength_history");
  void insertHistoricCardio(CardioDetails cardio) =>
      _insertItem(cardio.toMap(), "cardio_history");
  void insertSavedWorkout(FutureWorkout workout) =>
      _insertItem(workout.toMap(), "saved_workouts");
  void insertSavedExercise(int workoutId, int descriptionId, int position) =>
      _insertItem({
        'workout_id': workoutId,
        "description_id": descriptionId,
        "position": position,
      }, "saved_exercises");

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
          duration: maps[index]['length'],
        );
      },
    );
  }

  Future<List<HistoricExercise>> _getExercisesFromWorkout(
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
            //TODO reorder so that get exercise description is first, then choose based on exercise type
            db!,
            workoutID,
            maps[index]['position']);
        List<HistoricCardio> cardioList =
            await _getHistoricCardio(db, workoutID, maps[index]['position']);
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
          await _getExercisesFromWorkout(db, workoutData[index]['id']);
      return HistoricWorkout(
          id: workoutData[index]['id'],
          exercises: exercises,
          name: workoutData[index]['name'],
          date: workoutData[index]['date'],
          length: workoutData[index]['length']);
    }));
  }

  Future<List<ExerciseDescription>> _getSavedExercises(
      Database? db, int workoutID) async {
    db ??= await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'saved_exercises',
      columns: ['description_id'],
      where: 'workout_id = ?',
      whereArgs: [workoutID],
      orderBy: 'position',
    );
    return Future.wait(List.generate(
      maps.length,
      (index) async {
        return getExerciseDescription(db!, maps[index]['description_id']);
      },
    ));
  }

  Future<List<FutureWorkout>> getSavedWorkouts() async {
    final db = await _database;
    List<Map<String, dynamic>> workoutData = await db.query('saved_workouts');
    return Future.wait(List.generate(workoutData.length, (index) async {
      List<ExerciseDescription> exercises =
          await _getSavedExercises(db, workoutData[index]['id']);
      return FutureWorkout.fromDatabase(
        id: workoutData[index]['id'],
        exercises: exercises,
        name: workoutData[index]['name'],
        description: workoutData[index]['description'],
      );
    }));
  }

  Future<List<Map<DateTime, HistoricExercise>>> getExercisesFromDescription(
      //might want to add the mapping later so that I can return this list without it
      ExerciseDescription description) async {
    final db = await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'exercise_history, workout_history',
      columns: ['workout_id', 'date', 'position'],
      where:
          'description_ID = ? AND exercise_history.workout_id = workout_history.id',
      whereArgs: [description.id],
    );
    return Future.wait(List.generate(
      maps.length,
      (index) async {
        List<HistoricSet> setList = await _getHistoricSets(
            //TODO reorder so that get exercise description is first, then choose based on exercise type
            db,
            maps[index]['workout_id'],
            maps[index]['position']);
        List<HistoricCardio> cardioList = await _getHistoricCardio(
          db,
          maps[index]['workout_id'],
          maps[index]['position'],
        );
        return {
          DateTime.parse(maps[index]['date']): HistoricExercise(
            position: maps[index]['position'],
            description: description,
            sets: setList.isNotEmpty ? setList : cardioList,
          )
        };
      },
    ));
  }
}

// class ObjectBox {
//   late final Store _store
//   late final Box<>
// }
