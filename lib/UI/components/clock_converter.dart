class ClockConverter {
  ClockConverter();
  String secondsToFormatted(int number) {
    if (number < 60) {
      return number.toString() + 's';
    } else if (number % 60 > 10) {
      return (number ~/ 60).toString() + ':' + (number % 60).toString();
    } else {
      return (number ~/ 60).toString() + ':0' + (number % 60).toString();
    }
  }

  String iso8601ToFormatted(DateTime date) =>
      date.year.toString() +
      "-" +
      date.month.toString() +
      "-" +
      date.day.toString() +
      " " +
      (date.hour % 12).toString() +
      ":" +
      date.minute.toString() +
      (date.hour < 12 ? "AM" : "PM");
}
