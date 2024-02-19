extension CapitalizeFirstLetter on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    } else {
      return substring(0, 1).toUpperCase() + substring(1);
    }
  }
}
