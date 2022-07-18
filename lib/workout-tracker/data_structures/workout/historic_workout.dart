import '../structures.dart';

class HistoricWorkout implements Workout {
  final int _id;
  String _name;
  final List<HistoricExercise> _exercises;
  final DateTime _date;
  final int _length;

  HistoricWorkout(
      {required int id,
      required String name,
      required List<HistoricExercise> exercises,
      required String date,
      required int length})
      : _id = id,
        _name = name,
        _exercises = exercises,
        _date = DateTime.parse(date),
        _length = length;

  @override
  int get id => _id;
  @override
  String get name => _name;
  @override
  List<HistoricExercise> get exercises => _exercises;
  @override
  set name(String nm) => _name = nm;
  DateTime get date => _date;
  int get length => _length;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'date': _date.toIso8601String(),
      'length': _length,
    };
  }
}
