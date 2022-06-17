void createDatabase1(db, version) {
  db.execute('CREATE TABLE exercise_descriptions('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'description TEXT,'
      'exercise_type TEXT)');
  db.execute('CREATE TABLE equipment_list('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'description TEXT)');
  db.execute('CREATE TABLE equipment_list_exercise_map('
      'equipment_id REFERENCES equipment_list(id) ON DELETE CASCADE,'
      'exercise_id REFERENCES exercise_descriptions(id) ON DELETE CASCADE,'
      'PRIMARY KEY(equipment_id, exercise_id))');
  //TODO when adding the brain add a "muscles" table mapping exercises to muscle groups
  db.execute('CREATE TABLE workout_history('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'date TEXT,'
      'length INTEGER)');
  db.execute('CREATE TABLE exercise_history('
      'workout_id INTEGER REFERENCES workout_history(id) ON DELETE CASCADE,'
      'position INTEGER'
      'description_id INTEGER REFERENCES exercise_description(id) ON DELETE SET NULL'
      'PRIMARY KEY(workout_id, position))');
  db.execute('CREATE TABLE set_history('
      'workout_id INTEGER REFERENCES workout_history(id) ON DELETE CASCADE,'
      'exercise_position INTEGER,'
      'position INTEGER,'
      'weight REAL,' //assumed in kg, round to nearest 5 lbs
      'reps INTEGER,'
      'rest_time INTEGER'
      'RPE INTEGER,'
      'note TEXT,'
      'PRIMARY KEY(exercise_id, position))');
  db.execute('CREATE TABLE cardio_history('
      'workout_id INTEGER REFERENCES exercise_descriptions(id) ON DELETE CASCADE,'
      'exercise_position INTEGER,'
      'position INTEGER,'
      'length INTEGER,'
      'distance INTEGER,'
      'rest_time INTEGER'
      'calories INTEGER,'
      'note TEXT,'
      'PRIMARY KEY(exercise_ID, position))');
  db.execute('CREATE TABLE saved_workouts('
      'id INT PRIMARY KEY,'
      'name TEXT,'
      'description TEXT,'
      ')');
  db.execute(
      'CREATE TABLE saved_exercises(' //appropriate weight will be determined by model weighted on most recent weeks
      'workout_id INT REFERENCES saved_workouts(id) ON DELETE CASCADE,'
      'description_id INT REFERENCES exercise_descriptions(id) ON DELETE CASCADE,'
      'position INT,'
      'PRIMARY KEY(workout_id, position))');
  db.execute('CREATE TABLE workout_plans('
      'id INT PRIMARY KEY,'
      'name TEXT,'
      'description TEXT,'
      'length INT)');
  db.execute('CREATE TABLE plans_to_saved_workouts('
      'plan_id INT REFERENCES workout_plans(id) ON DELETE CASCADE,'
      'workout_id INT REFERENCES saved_workouts(id) ON DELETE CASCADE,'
      'order INT,'
      'PRIMARY KEY(plan_id, workout_id))');
}
