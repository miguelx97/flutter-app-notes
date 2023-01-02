class ReminderTime {
  static const int oneDay = 1440;
  static const int oneHour = 60;
  static const int quarterHour = 15;

  static String getLabel(int reminderTime) {
    switch (reminderTime) {
      case ReminderTime.oneDay:
        return '15 minutos antes';
      case ReminderTime.oneHour:
        return 'Una hora antes';
      case ReminderTime.quarterHour:
        return 'Un día antes';
    }
    return '';
  }
}
