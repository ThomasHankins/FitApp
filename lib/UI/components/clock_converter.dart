class ClockConverter {
  ClockConverter();
  String convert(int number) {
    //TODO MAKE THIS THE CONSTRUCTOR!!!!!!!!!!!!!!!!!!!!
    if (number < 60) {
      return number.toString() + 's';
    } else if (number % 60 > 10) {
      return (number ~/ 60).toString() + ':' + (number % 60).toString();
    } else {
      return (number ~/ 60).toString() + ':0' + (number % 60).toString();
    }
  }
}
