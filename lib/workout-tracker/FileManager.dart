import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
