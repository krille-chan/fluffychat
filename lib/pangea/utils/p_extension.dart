extension IsAtLeastYearsOld on DateTime {
  bool isAtLeastYearsOld(int years) {
    final now = DateTime.now();
    final boundaryDate = DateTime(now.year - years, now.month, now.day);

    // Discard the time from [this].
    final thisDate = DateTime(year, month, day);

    // Did [thisDate] occur on or before [boundaryDate]?
    return thisDate.compareTo(boundaryDate) <= 0;
  }
}
