import 'details.dart';

class StrengthDetails extends SetDetails {
  double weight;
  int reps;
  int? _rpe;

  int? get rpe => _rpe;
  set rpe(int? rpe) => (rpe! >= 0 || rpe <= 10) ? _rpe = rpe : null;

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
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
