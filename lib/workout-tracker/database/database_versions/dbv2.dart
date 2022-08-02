void createDatabase2(db, version) {
  db.execute('CREATE TABLE exercise_descriptions('
      'name TEXT PRIMARY KEY,'
      'description TEXT DEFAULT NULL,'
      'exercise_type TEXT NOT NULL,' //strength or cardio
      'parent_exercise DEFAULT NULL' //this is to allow sub categories of exercises eg. different types of bench press
      'descriptor DEFAULT NULL);'); //use something like "per leg" just to clarify when adding weight

  db.execute('CREATE TABLE equipment_list('
      'name TEXT PRIMARY KEY,'
      'description TEXT);');

  db.execute(
      'CREATE TABLE equipment_list_exercise_map(' //one-to-many relationship
      'equipment_name TEXT REFERENCES equipment_list(name) ON DELETE CASCADE,'
      'exercise_name TEXT REFERENCES exercise_descriptions(name) ON DELETE CASCADE,'
      'PRIMARY KEY(equipment_name, exercise_name))');

  //TODO when adding the brain add a "muscles" table and mapping table for exercises to muscle groups

  db.execute('CREATE TABLE workout_history('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name TEXT,'
      'date TEXT,'
      'length INTEGER);' //duration in seconds
      );

  db.execute('CREATE TABLE set_history('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'exercise_name TEXT REFERENCES exercise_descriptions(name),'
      'workout_id INTEGER REFERENCES workout_history(id) ON DELETE CASCADE,'
      'position INTEGER,'
      'time_marker INTEGER,' //in seconds since start of workout
      'UNIQUE(workout_id, position));');

  db.execute('CREATE TABLE strength_history('
      'set_id INTEGER PRIMARY KEY REFERENCES set_history(id) ON DELETE CASCADE,'
      'weight REAL,' //assumed in lb (for now)
      'reps INTEGER,'
      'RPE INTEGER,'
      'rest_time INTEGER,'
      'note TEXT);');
  db.execute('CREATE TABLE cardio_history('
      'set_id INTEGER PRIMARY KEY REFERENCES set_history(id) ON DELETE CASCADE,'
      'duration INTEGER,'
      'distance INTEGER,'
      'calories INTEGER,'
      'rest_time INTEGER,'
      'note TEXT);');

  db.execute('CREATE TABLE saved_workouts('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name TEXT,'
      'description TEXT'
      ');');
  db.execute(
      'CREATE TABLE saved_exercises(' //appropriate weight will be determined by model weighted on most recent weeks
      'workout_id INTEGER REFERENCES saved_workouts(id) ON DELETE CASCADE,'
      'description_name INTEGER REFERENCES exercise_descriptions(name) ON DELETE CASCADE,'
      'position INTEGER,'
      'PRIMARY KEY(workout_id, position));');

  //TODO implement workout plans as below

  // db.execute('CREATE TABLE workout_plans('
  //     'id INTEGER PRIMARY KEY,'
  //     'name TEXT,'
  //     'description TEXT,'
  //     'length INT);');
  // db.execute('CREATE TABLE plans_to_saved_workouts('
  //     'plan_id INTEGER REFERENCES workout_plans(id) ON DELETE CASCADE,'
  //     'workout_id INTEGER REFERENCES saved_workouts(id) ON DELETE CASCADE,'
  //     'position INTEGER,'
  //     'PRIMARY KEY(plan_id, workout_id));');
}
