import '../structures.dart';

class HistoricWorkout implements Workout {
  final int _id;
  final String _name;
  final List<ExerciseSet> _sets;
  final DateTime _date;
  final int _length;

  HistoricWorkout(
      {required int id,
      required String name,
      required List<ExerciseSet> sets,
      required String date,
      required int length})
      : _id = id,
        _name = name,
        _sets = sets,
        _date = DateTime.parse(date),
        _length = length;

  int get id => _id;
  String get name => _name;

  List<ExerciseSet> get sets => _sets;
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
