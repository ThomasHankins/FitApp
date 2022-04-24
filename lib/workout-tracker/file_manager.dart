import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'exercise.dart';
import 'workout.dart';

class DatabaseManager {
  static int? _currentWorkoutID;
  static int? _currentExerciseID;

  get workoutID async {
    _currentWorkoutID ??= await _generateWorkoutID();
    _currentWorkoutID = _currentWorkoutID! + 1;
    return _currentWorkoutID;
  }

  get exerciseID async {
    _currentExerciseID ??= await _generateWorkoutID();
    _currentExerciseID = _currentExerciseID! + 1;
    return _currentExerciseID;
  }

  void ensureInit() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<Database> get _database async {
    return openDatabase(
      join(await getDatabasesPath(), 'workout_database.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE workout_history('
            'id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'date TEXT,'
            'length INTEGER)');
        db.execute('CREATE TABLE exercise_descriptions('
            'id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'description TEXT,'
            'muscle_group STRING,' //will make this reference muscleGroup DB when implemented
            'is_compound INTEGER,'
            'is_machine INTEGER)');
        db.execute('CREATE TABLE exercise_history('
            'id INTEGER PRIMARY KEY,'
            'workout_id INTEGER REFERENCES workout_history(id) ON DELETE CASCADE,'
            'description_id INTEGER REFERENCES exercise_description(id) ON DELETE SET NULL');
        db.execute('CREATE TABLE set_history('
            'exercise_id INTEGER REFERENCES exercise_descriptions(id) ON DELETE CASCADE,'
            'position INTEGER,'
            'weight REAL,'
            'reps INTEGER,'
            'RPE INTEGER,'
            'note TEXT,'
            'in_KG INTEGER,'
            'PRIMARY KEY(exercise_ID, position))');
        //TODO add template workout database
        //includes list of exercise descriptions and id
        //TODO add some sort of plan database
        //includes a list of template workouts, id, some kind of progression
        //TODO database with workout id and plan id and date
      },
      version: 1, //INITIAL VERSION
    );
  }

  //Inserting
  Future<void> _insertExerciseSet(Database db, ExerciseSet exerciseSet) async {
    await db.insert(
      'set_history',
      exerciseSet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> _insertExercise(Database db, Exercise exercise) async {
    //add sets to sets to database
    for (ExerciseSet set in exercise.sets) {
      _insertExerciseSet(db, set);
    }
    await db.insert(
      'exercise_history',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await _database;

    for (Exercise ex in workout.exercises) {
      _insertExercise(db, ex);
    }
    await db.insert(
      'workout_history',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }
  //TODO add inserting plans

  //Deleting
  Future<void> deleteWorkout(int workoutID) async {
    final db = await _database;
    await db.delete(
      'workout_history',
      where: 'id = ?',
      whereArgs: [workoutID],
    ); //don't need to do anything else since changes cascade
  }
  //TODO ADD DELETING PLANS

  //Data Retrieval
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
          muscleGroup: maps[index]['muscle_group'],
          isCompound: maps[index]['is_compound'],
          isMachine: maps[index]['is_machine']);
    }));
  }

  Future<ExerciseDescription> _getExerciseDescription(
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
      muscleGroup: maps[0]['muscle_group'],
      isCompound: maps[0]['is_compound'],
      isMachine: maps[0]['is_machine'],
    );
  }

  Future<List<Exercise>> _getExercises(Database? db, int workoutID) async {
    db ??= await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'exercise_history',
      where: 'workout_id = ?',
      whereArgs: [workoutID],
    );

    return Future.wait(List.generate(
      maps.length,
      (index) async {
        List<ExerciseSet> setList =
            await _getExerciseSets(db!, maps[index]['id']);
        ExerciseDescription description =
            await _getExerciseDescription(db, maps[index]['description_id']);
        return Exercise.fromDatabase(
          id: maps[index]['id'],
          workoutID: maps[index]['workout_id'],
          descriptionID: maps[index]['description_id'],
          sets: setList,
          exerciseDescription: description,
        );
      },
    ));
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await _database;
    List<Map<String, dynamic>> workoutData = await db.query('workout_history');
    return Future.wait(List.generate(workoutData.length, (index) async {
      List<Exercise> exercises =
          await _getExercises(db, workoutData[index]['id']);
      return Workout.fromHistoric(
          oldID: workoutData[index]['id'],
          oldExercises: exercises,
          oldName: workoutData[index]['name'],
          oldDate: workoutData[index]['date'],
          oldLength: workoutData[index]['length']);
    }));
  }

  //TODO ADD GET PLANS USING ID

  //Accessing the database to find ID values
  Future<int> _generateWorkoutID() async {
    final db = await _database;
    final List<Map<String, Object?>> id = await db.rawQuery('SELECT MAX(id)'
        'FROM workout_history;');

    int? tempID = int.tryParse(id.first.values.first.toString());
    tempID ??= 0;
    return tempID;
  }

  Future<int> _generateExerciseID() async {
    final db = await _database;
    final List<Map<String, Object?>> id = await db.rawQuery('SELECT MAX(id)'
        'FROM exercise_history;');

    int? tempID = int.tryParse(id.first.values.first.toString());
    tempID ??= 0;
    return tempID;
  }
}
