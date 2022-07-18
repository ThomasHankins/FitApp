import 'details.dart';

class CardioDetails extends SetDetails {
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
}
