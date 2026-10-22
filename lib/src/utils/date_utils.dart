import 'package:awesome_calendart/src/data/locale.dart';
import 'package:flutter/material.dart';

class AwesomeDateUtils {
  static String getMonthAndYear(DateTime date, LocaleType locale) {
    List<String> months = getMonthsNames(locale);
    return "${months[date.month - 1]} ${date.year}";
  }

  static DateTime getNextMonth(DateTime date) {
    if (date.month != 12) {
      return DateTime(date.year, date.month + 1, 1);
    } else {
      return DateTime(date.year + 1, 1, 1);
    }
  }

  static DateTime getPreviousMonth(DateTime date) {
    if (date.month != 1) {
      return DateTime(date.year, date.month - 1, 1);
    } else {
      return DateTime(date.year - 1, 12, 1);
    }
  }

  static int getDaysInMonth(DateTime date) {
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  /// Number of cells before the 1st of the month in a Monday-first week.
  static int getFirstWeekdayOffset(DateTime month) {
    return DateTime(month.year, month.month, 1).weekday - 1;
  }

  static List<String> getShortWeekdayNames(LocaleType locale) {
    switch (locale) {
      case LocaleType.en:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case LocaleType.fr:
        return ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      case LocaleType.de:
        return ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
      case LocaleType.es:
        return ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      case LocaleType.it:
        return ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
      case LocaleType.pl:
        return ['Pon', 'Wto', 'Śro', 'Czw', 'Pią', 'Sob', 'Nie'];
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
      case LocaleType.pl:
        return [
          'Poniedziałek',
          'Wtorek',
          'Środa',
          'Czwartek',
          'Piątek',
          'Sobota',
          'Niedziela'
        ];
    }
  }

  static List<String> getMonthsNames(LocaleType locale) {
    switch (locale) {
      case LocaleType.en:
        return [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
      case LocaleType.fr:
        return [
          'Janvier',
          'Février',
          'Mars',
          'Avril',
          'Mai',
          'Juin',
          'Juillet',
          'Août',
          'Septembre',
          'Octobre',
          'Novembre',
          'Décembre'
        ];
      case LocaleType.de:
        return [
          'Januar',
          'Februar',
          'März',
          'April',
          'Mai',
          'Juni',
          'Juli',
          'August',
          'September',
          'Oktober',
          'November',
          'Dezember'
        ];
      case LocaleType.es:
        return [
          'Enero',
          'Febrero',
          'Marzo',
          'Abril',
          'Mayo',
          'Junio',
          'Julio',
          'Agosto',
          'Septiembre',
          'Octubre',
          'Noviembre',
          'Diciembre'
        ];
      case LocaleType.it:
        return [
          'Gennaio',
          'Febbraio',
          'Marzo',
          'Aprile',
          'Maggio',
          'Giugno',
          'Luglio',
          'Agosto',
          'Settembre',
          'Ottobre',
          'Novembre',
          'Dicembre'
        ];
      case LocaleType.pl:
        return [
          'Styczeń',
          'Luty',
          'Marzec',
          'Kwiecień',
          'Maj',
          'Czerwiec',
          'Lipiec',
          'Sierpień',
          'Wrzesień',
          'Październik',
          'Listopad',
          'Grudzień'
        ];
    }
  }
}
