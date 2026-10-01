import 'package:intl/intl.dart';

// Utilitário para formatação de datas e horas em pt-BR.
class DateFormatter {
  // Retorna a data no formato 01/10/2026.
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Retorna o horário no formato 08:30:15.
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }

  // Retorna data e hora completas.
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Retorna dia da semana por extenso.
  static String formatWeekDay(DateTime date) {
    final Map<int, String> days = {
      1: 'Segunda-feira',
      2: 'Terça-feira',
      3: 'Quarta-feira',
      4: 'Quinta-feira',
      5: 'Sexta-feira',
      6: 'Sábado',
      7: 'Domingo',
    };
    return days[date.weekday] ?? '';
  }
}
