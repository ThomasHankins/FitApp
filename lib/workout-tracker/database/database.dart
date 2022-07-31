import 'dart:async';

import 'package:fit_app/workout-tracker/data_structures/sets/details/detail_types.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/details_cardio.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/details_strength.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/future_workout.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/historic_workout.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/live_workout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data_structures/structures.dart';
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
  void insertExerciseDescription(ExerciseDescription ed) =>
      _insertItem(ed.toMap(), "exercise_descriptions");
  Future<int> insertLiveWorkout(LiveWorkout workout) async =>
      await _insertItem(workout.toMap(), "workout_history");
  Future<int> insertHistoricSet(ExerciseSet set) async =>
      await _insertItem(set.toMap(), "set_history");
  void insertHistoricStrength(StrengthDetails set) =>
      _insertItem(set.toMap(), "strength_history");
  void insertHistoricCardio(CardioDetails cardio) =>
      _insertItem(cardio.toMap(), "cardio_history");
  Future<int> insertSavedWorkout(FutureWorkout workout) async =>
      await _insertItem(workout.toMap(), "saved_workouts");
  void insertSavedExercise(int workoutId, String name, int position) =>
      _insertItem({
        'workout_id': workoutId,
        "description_name": name,
        "position": position,
      }, "saved_exercises");

  Future<int> _insertItem(var item, String table) async {
    final db = await _database;
    await db.insert(
      table,
      item,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    int id = 0;
    try {
      final List<Map<String, Object?>> idString =
          await db.rawQuery('SELECT MAX(id)'
              'FROM $table;');
      id = int.parse(idString.first.values.first.toString());
    } catch (e) {
      id = -1;
    }

    return id;
  }

  //Updating
  void updateLiveWorkout(LiveWorkout workout) =>
      _updateItem(workout, "workout_history", 'id = ?', workout.id);
  void updateExerciseDescription(ExerciseDescription ed) =>
      _updateItem(ed, "exercise_descriptions", 'name = ?', ed.name);
  // void updatePlan(WorkoutPlan plan) => _updateItem(plan, "workout_plans");

  Future<void> _updateItem(
      dynamic item, String table, String whereStatement, var whereArg) async {
    final db = await _database;
    await db.update(table, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: whereStatement,
        whereArgs: [whereArg]);
  }

  //Deleting

  void deleteExerciseDescription(ExerciseDescription ed) =>
      _deleteItem(ed.name, "exercise_descriptions", 'name = ?');
  void deleteSet(ExerciseSet set) => _deleteItem(set.id, "set_history");
  void deleteHistoricWorkout(int id) => _deleteItem(id, "workout_history");
  void deleteSavedWorkout(int id) => _deleteItem(id, "saved_workouts");
  // void deletePlan(int id) => _deleteItem(id, "workout_plans");

  Future<void> _deleteItem(var whereArg, String table,
      [String? whereStatement]) async {
    final db = await _database;
    await db.delete(
      table,
      where: whereStatement ?? 'id = ?',
      whereArgs: [whereArg],
    );
  }

  //Data Retrieval

  Future<ExerciseDescription> getExerciseDescription(
      Database db, String descName) async {
    List<Map<String, dynamic>> maps = await db.query(
      'exercise_descriptions',
      where: 'name = ?',
      whereArgs: [descName],
    );

    ExerciseDescription? parentExercise;
    String? parentExerciseName = maps[0]['parent'];

    if (parentExerciseName != null) {
      parentExercise = await getExerciseDescription(db, parentExerciseName);
    }

    return ExerciseDescription.fromDatabase(
      name: maps[0]['name'],
      description: maps[0]['description'],
      exerciseType: maps[0]['exercise_type'],
      parentExercise: parentExercise,
      descriptor: maps[0]['descriptor'],
    );
  }

  Future<List<ExerciseDescription>> getExerciseDescriptionList() async {
    final db = await _database;
    List<Map<String, dynamic>> maps = await db.query('exercise_descriptions');

    ExerciseDescription? parentExercise;
    String? parentExerciseName;

    return Future.wait(List.generate(maps.length, (index) async {
      parentExercise = null;
      parentExerciseName = maps[index]['parent'];

      if (parentExerciseName != null) {
        parentExercise = await getExerciseDescription(db, parentExerciseName!);
      }

      DetailType? type;

      maps[index]['exercise_type'] == 'strength'
          ? type = DetailType.strength
          : type = DetailType.cardio;

      return ExerciseDescription.fromDatabase(
        name: maps[index]['name'],
        description: maps[index]['description'],
        exerciseType: type,
        parentExercise: parentExercise,
        descriptor: maps[index]['descriptor'],
      );
    }));
  }

  Future<List<ExerciseSet>> _getSetsFromWorkout(
      Database db, int workoutID) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'set_history',
      where: 'workout_id = ?', //referencing the specific exercise instance
      whereArgs: [workoutID],
    );

    return Future.wait(List.generate(maps.length, (index) async {
      ExerciseDescription ed =
          await getExerciseDescription(db, maps[index]['exercise_name']);

      SetDetails? details;
      if (ed.exerciseType == DetailType.strength) {
        details = await _getStrengthDetails(db, maps[index]['id']);
      } else if (ed.exerciseType == DetailType.cardio) {
        details = await _getCardioDetails(db, maps[index]['id']);
      }
      return ExerciseSet.fromDatabase(
          description: ed,
          details: details!,
          workoutId: workoutID,
          id: maps[index]['id'],
          time: maps[index]['time'],
          position: maps[index]['position']);
    }));
  }

  Future<StrengthDetails> _getStrengthDetails(Database db, int setID) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'strength_history',
      where: 'set_id = ?', //referencing the specific exercise instance
      whereArgs: [setID],
    );
    return StrengthDetails(
      note: maps[0]['note'],
      restTime: maps[0]['restTime'],
      weight: maps[0]['weight'],
      reps: maps[0]['reps'],
      rpe: maps[0]['rpe'],
    );
  }

  Future<CardioDetails> _getCardioDetails(Database db, int setID) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'cardio_history',
      where: 'set_id = ?', //referencing the specific exercise instance
      whereArgs: [setID],
    );
    return CardioDetails(
      note: maps[0]['note'],
      calories: maps[0]['calories'],
      distance: maps[0]['distance'],
      restTime: maps[0]['rest_time'],
      duration: maps[0]['length'],
    );
  }

  Future<List<HistoricWorkout>> getHistoricWorkouts() async {
    final db = await _database;
    List<Map<String, dynamic>> workoutData = await db.query('workout_history');
    return Future.wait(List.generate(workoutData.length, (index) async {
      List<ExerciseSet> sets =
          await _getSetsFromWorkout(db, workoutData[index]['id']);
      return HistoricWorkout(
        id: workoutData[index]['id'],
        sets: sets,
        name: workoutData[index]['name'],
        date: workoutData[index]['date'],
        length: workoutData[index]['length'],
      );
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
        sets: exercises,
        name: workoutData[index]['name'],
        description: workoutData[index]['description'],
      );
    }));
  }

  Future<List<Map<DateTime, ExerciseSet>>> getSetsFromDescription(
      //might want to add the mapping later so that I can return this list without it
      ExerciseDescription description) async {
    final db = await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'set_history, workout_history',
      columns: ['workout_id', 'set_id', 'date', 'position'],
      where:
          'exercise_name = ? AND set_history.workout_id = workout_history.id',
      whereArgs: [description.name],
    );

    return Future.wait(List.generate(
      maps.length,
      (index) async {
        SetDetails? details;
        if (description.exerciseType == DetailType.strength) {
          details = await _getStrengthDetails(db, maps[index]['id']);
        } else if (description.exerciseType == DetailType.cardio) {
          details = await _getCardioDetails(db, maps[index]['id']);
        }

        return {
          DateTime.parse(maps[index]['date']): ExerciseSet.fromDatabase(
              description: description,
              details: details!,
              workoutId: maps[index]['workout_history.id'],
              id: maps[index]['set_history.id'],
              time: maps[index]['time'],
              position: maps[index]['position'])
        };
      },
    ));
  }
}

// class ObjectBox {
//   late final Store _store
//   late final Box<>
// }
