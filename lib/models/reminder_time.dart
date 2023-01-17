class ReminderTime {
  static const int oneDay = 1440;
  static const int oneHour = 60;
  static const int quarterHour = 15;
  static const int justOnTime = 1;

  static String getLabel(int reminderTime) {
    switch (reminderTime) {
      case ReminderTime.quarterHour:
        return '15 minutos antes';
      case ReminderTime.oneHour:
        return 'Una hora antes';
      case ReminderTime.oneDay:
        return 'Un día antes';
      case ReminderTime.justOnTime:
        return 'Al momento';
      default:
        return '';
    }
  }

  static String name(int reminderTime) {
    switch (reminderTime) {
      case ReminderTime.quarterHour:
        return '15 minutos';
      case ReminderTime.oneHour:
        return 'una hora';
      case ReminderTime.oneDay:
        return 'un día';
      default:
        return '';
    }
  }
}
