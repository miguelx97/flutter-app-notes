import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static MaterialColor customColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static dateFormat(DateTime? date) {
    if (date == null) return '';
    return DateFormat.yMMMMd('es').format(date!);
  }

  static String dateTimeFormat(DateTime date, TimeOfDay? time) {
    if (time == null) {
      return DateFormat('dd / MM / yyyy').format(date);
    }
    final combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return DateFormat('dd / MM / yyyy  -  HH : mm').format(combinedDateTime);
  }

  static void navigateBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(context, '');
    }
  }
}
