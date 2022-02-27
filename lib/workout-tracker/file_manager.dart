import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'exercise.dart';
import 'workout.dart';

class DatabaseManager {
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
      },
      //add lines for inserting exercises
      version: 1, //INITIAL VERSION
    );
  }

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

  Future<void> deleteWorkout(int workoutID) async {
    final db = await _database;
    await db.delete(
      'workout_history',
      where: 'id = ?',
      whereArgs: [workoutID],
    ); //don't need to do anything else since changes cascade
  }

  Future<List<ExerciseSet>> _getExerciseSets(
      Database db, int exerciseID) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'set_history',
      where: 'exercise_id = ?',
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

  Future<List<Exercise>> _getExercises(Database db, int workoutID) async {
    List<Map<String, dynamic>> maps = await db.query(
      'exercise_history',
      where: 'workout_id = ?',
      whereArgs: [workoutID],
    );

    return Future.wait(List.generate(
      maps.length,
      (index) async {
        List<ExerciseSet> setList =
            await _getExerciseSets(db, maps[index]['id']);
        return Exercise.fromDatabase(
          id: maps[index]['id'],
          workoutID: maps[index]['workout_id'],
          descriptionID: maps[index]['description_id'],
          sets: setList,
        );
      },
    ));
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await _database;
    List<Map<String, dynamic>> workoutData = await db.query('workout_history');
    return List.generate(workoutData.length, (index) {
      Workout.fromHistoric();
    });
  }

  Future<int?> generateWorkoutID() async {
    final db = await _database;
    final List<Map<String, Object?>> id = await db.rawQuery('SELECT MAX(id)'
        'FROM workout_history;');

    return int.tryParse(id.first.values.first.toString());
  }

  Future<int?> generateExerciseID() async {
    final db = await _database;
    final List<Map<String, Object?>> id = await db.rawQuery('SELECT MAX(id)'
        'FROM exercise_history;');

    return int.tryParse(id.first.values.first.toString());
  }
}

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _plansFile async {
    final path = await _localPath;
    if (!File('$path/workoutPlans.json').existsSync()) {
      String data = await rootBundle.loadString("data/workoutPlans.json");
      File('$path/workoutPlans.json').writeAsString(data);
    }
    return File('$path/workoutPlans.json');
  }

  Future<File> get _historyFile async {
    final path = await _localPath;
    if (!File('$path/workoutHistory.json').existsSync()) {
      String data = await rootBundle.loadString("data/workoutHistory.json");
      File('$path/workoutHistory.json').writeAsString(data);
    }
    return File('$path/workoutHistory.json');
  }

  Future<File> get _exercisesFile async {
    final path = await _localPath;
    if (!File('$path/exercises.json').existsSync()) {
      String data = await rootBundle.loadString("data/exercises.json");
      File('$path/exercises.json').writeAsString(data);
    }
    return File('$path/exercises.json');
  }

  Future<File> get _programsFile async {
    final path = await _localPath;
    if (!File('$path/workoutPrograms.json').existsSync()) {
      String data = await rootBundle.loadString("data/workoutPrograms.json");
      File('$path/workoutPrograms.json').writeAsString(data);
    }
    return File('$path/workoutPrograms.json');
  }

  Future<String> readFile(String filename) async {
    try {
      switch (filename) {
        case 'exercises':
          final file = await _exercisesFile;
          final String contents = await file.readAsString();
          return contents;

        case 'history':
          final file = await _historyFile;
          final String contents = await file.readAsString();
          return contents;

        case 'plans':
          final file = await _plansFile;
          final String contents = await file.readAsString();
          return contents;

        case 'programs':
          final file = await _programsFile;
          final String contents = await file.readAsString();
          return contents;

        default:
          return "";
      }
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File?> writeFile(String filename, String newText) async {
    switch (filename) {
      case 'exercises':
        final file = await _exercisesFile;
        return file.writeAsString(newText);

      case 'history':
        final file = await _historyFile;
        return file.writeAsString(newText);

      case 'plans':
        final file = await _plansFile;
        return file.writeAsString(newText);

      case 'programs':
        final file = await _programsFile;
        return file.writeAsString(newText);
      default:
        return null;
    }
  }
}
