
extension DateTimeExtensions on DateTime {
  /// 获取前一个月的DateTime
  DateTime get previousMonth {
    int previousMonth = month - 1;
    int previousYear = year;

    if (previousMonth == 0) {
      previousMonth = 12;
      previousYear--;
    }

    return DateTime(previousYear, previousMonth, day);
  }

  /// 获取后一个月的DateTime
  DateTime get nextMonth {
    int nextMonth = month + 1;
    int nextYear = year;

    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }

    return DateTime(nextYear, nextMonth, day);
  }

  // 获取前一年的DateTime
  DateTime get previousYear{
    return DateTime(year - 1, month, day);
  }

// 获取后一年的DateTime
  DateTime get nextYear{
    return DateTime(year + 1, month, day);
  }
}


