import 'package:sqflite/sqflite.dart';

void addExercises(db) {
  //TODO add a different method like JSON for storing default exercises

  List<Map<String, dynamic>> exercises = [
    {
      "id": 1,
      "name": "Squat",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 2,
      "name": "Bench Press",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 3,
      "name": "Shoulder Press",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 4,
      "name": "Deadlift",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 5,
      "name": "Tricep Dip",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 6,
      "name": "Preacher Curl",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 7,
      "name": "Skull Crusher",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 8,
      "name": "Cable Tricep Pushdown",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 9,
      "name": "Pull-Up",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 10,
      "name": "Machine Shoulder Press",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 11,
      "name": "Machine Fly",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 12,
      "name": "Machine Reverse Fly",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 13,
      "name": "Machine Curl",
      "description": "",
      "exercise_type": "strength",
    },
    {
      "id": 14,
      "name": "Overhead Tricep Press",
      "description": "",
      "exercise_type": "strength",
    },
  ];

  Future<void> _insertItem(var item) async {
    await db.insert(
      "exercise_descriptions",
      item,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  for (Map<String, dynamic> i in exercises) {
    _insertItem(i);
  }
}
