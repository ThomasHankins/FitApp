import 'package:fit_app/workout-tracker/database/database.dart';

import 'details.dart';

class StrengthDetails extends SetDetails {
  late final int _setId;
  double weight;
  int reps;
  int? _rpe;

  int? get rpe => _rpe;
  set rpe(int? rpe) => (rpe! >= 0 || rpe <= 10) ? _rpe = rpe : null;

  String get weightAsString =>
      weight.toStringAsFixed(weight.truncateToDouble() == weight ? 0 : 1);

  StrengthDetails(
      {required String note,
      required int restTime,
      required this.weight,
      required this.reps,
      required int? rpe})
      : _rpe = rpe,
        super(
          restTime: restTime,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'set_id': _setId,
      'weight': weight,
      'reps': reps,
      'RPE': _rpe,
      'rest_time': restedTime,
      'note': note,
    };
  }

  @override
  void saveToDatabase(int setId) {
    _setId = setId;
    DatabaseManager().insertHistoricStrength(this);
  }
}
