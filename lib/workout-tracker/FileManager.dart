import 'dart:async';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class HistoryManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;

  }


  Future<File> get _localFile async {
    final path = await _localPath;

    if(!File('$path/workoutHistory.json').existsSync()){
      String data = await rootBundle.loadString("data/workoutHistory.json");
      File('$path/workoutHistory.json').writeAsString(data);
    }

    return File('$path/workoutHistory.json');
  }

  Future<String> readHistory() async {
    try {
      final file = await _localFile;

      // Read the file
      final String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeHistory(String history) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(history);
  }
}