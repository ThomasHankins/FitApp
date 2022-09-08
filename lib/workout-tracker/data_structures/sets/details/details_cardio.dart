import 'package:fit_app/workout-tracker/database/database.dart';

import 'details.dart';

class CardioDetails extends SetDetails {
  late final int _setId;
  int duration;
  int distance;
  int? calories;

  CardioDetails(
      {required String note,
      required int restTime,
      required this.duration,
      required this.distance,
      this.calories})
      : super(
          restTime: restTime,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'set_id': _setId,
      'duration': duration,
      'distance': distance,
      'calories': calories,
      'rest_time': restedTime,
      'note': note,
    };
  }
  @override
  String toString() {
    return super.toString();
  }

  @override
  void saveToDatabase(int setId) {
    _setId = setId;
    DatabaseManager().insertHistoricCardio(this);
  }
}
