// Import the test package and Counter class
import 'package:fit_app/workout-tracker/database/database.dart';
import 'package:test/test.dart';

void main() {
  test('Should load query', () {
    final DatabaseManager testDB = DatabaseManager();
    testDB.testFunc();
  });
}
