import 'package:fit_app/workout-tracker/database/database.dart';

import '../../../structures.dart';

Future<SetDetails> lastSet(
    ExerciseDescription description, int position) async {
  List<ExerciseSet> sets =
      await DatabaseManager().getMostRecentSets(description);

  if (sets.isEmpty) return SetDetails.blank(description);
  if (position > sets.length) position = sets.length;

  return sets[position].details;
}
