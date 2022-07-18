abstract class Workout {
  set name(String nm);

  int get id;
  String get name;
  List<void> get exercises;

  Map<String, dynamic> toMap();
}
