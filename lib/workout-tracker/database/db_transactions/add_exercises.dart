import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

Future<String> getJson() {
  return rootBundle.loadString('exercises.json');
}

void addExercises(Database db) async {
  List<Map<String, dynamic>> exercises = json.decode(await getJson());

  void _updateItem(Map<String, dynamic> item) async {
    await db.update(
      "exercise_descriptions",
      item,
      where: 'name = ?',
      whereArgs: [item['name']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertItem(var item) async {
    await db.insert(
      "exercise_descriptions",
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int i = 0;
  for (Map<String, dynamic> exercise in exercises) {
    try {
      _updateItem(exercise);
    } catch (e) {
      _insertItem;
    }
    i++;
  }
}
