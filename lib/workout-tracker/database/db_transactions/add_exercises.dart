import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

Future<String> getJson() {
  return rootBundle.loadString('default_exercises.json');
}

void addExercises(Database db) async {
  List<Map<String, dynamic>> exercises = json.decode(await getJson());

  Future<void> _insertItem(var item) async {
    await db.insert(
      "exercise_descriptions",
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int i = 0;
  for (Map<String, dynamic> exercise in exercises) {
    _insertItem(exercise);
    i++;
  }
}
