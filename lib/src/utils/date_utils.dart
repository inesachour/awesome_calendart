import 'package:awesome_calendart/src/data/locale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AwesomeDateUtils {
  static String getMonthAndYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static DateTime getNextMonth(DateTime date) {
    if (date.month != 12) {
      return DateTime(date.year, date.month + 1, 1);
    } else {
      return DateTime(date.year + 1, 1, 1);
    }
  }

  static getPreviousMonth(DateTime date) {
    if (date.month != 1) {
      return DateTime(date.year, date.month - 1, 1);
    } else {
      return DateTime(date.year - 1, 12, 1);
    }
  }

  static getDaysInMonth(DateTime date) {
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  static List<String> getShortWeekdayNames(LocaleType locale) {
    switch (locale) {
      case LocaleType.en:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case LocaleType.fr:
        return ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      case LocaleType.de:
        return ['Mon', 'Die', 'Mit', 'Don', 'Fre', 'Sam', 'Son'];
      case LocaleType.es:
        return ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      case LocaleType.it:
        return ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
    }
  }

  static List<String> getFullWeekdayNames(LocaleType locale) {
    switch (locale) {
      case LocaleType.en:
        return [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ];
      case LocaleType.fr:
        return [
          'Lundi',
          'Mardi',
          'Mercredi',
          'Jeudi',
          'Vendredi',
          'Samedi',
          'Dimanche'
        ];
      case LocaleType.de:
        return [
          'Montag',
          'Dienstag',
          'Mittwoch',
          'Donnerstag',
          'Freitag',
          'Samstag',
          'Sonntag'
        ];
      case LocaleType.es:
        return [
          'Lunes',
          'Martes',
          'Miércoles',
          'Jueves',
          'Viernes',
          'Sábado',
          'Domingo'
        ];
      case LocaleType.it:
        return [
          'Lunedì',
          'Martedì',
          'Mercoledì',
          'Giovedì',
          'Venerdì',
          'Sabato',
          'Domenica'
        ];
    }
  }
}
