import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

Future<String> getJson() {
  return rootBundle.loadString('data/exercises.json');
}

void addExercises(Database db) async {
  final exercises = json.decode(await getJson());

  Future<void> _insertItem(var item) async {
    await db.insert(
      "exercise_descriptions",
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  for (Map<String, dynamic> exercise in exercises) {
    _insertItem(exercise);
  }
}

void updateExercises(Database db) async {
  final exercises = json.decode(await getJson());

  void _updateItem(Map<String, dynamic> item) async {
    await db.update(
      "exercise_descriptions",
      item,
      where: 'name = ?',
      whereArgs: [item['name']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  for (Map<String, dynamic> exercise in exercises) {
    _updateItem(exercise);
  }
}
