class DateFormatter {
  static String format(String dateString) {
    if (dateString.isEmpty) return 'Data desconhecida';

    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

      if (difference.inDays >= 365) {
        int years = (difference.inDays / 365).floor();
        return 'Atualizado há $years ${years == 1 ? 'ano' : 'anos'}';
      } else if (difference.inDays >= 30) {
        int months = (difference.inDays / 30).floor();
        return 'Atualizado há $months ${months == 1 ? 'mês' : 'meses'}';
      } else if (difference.inDays > 0) {
        return 'Atualizado há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
      } else if (difference.inHours > 0) {
        return 'Atualizado há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else if (difference.inMinutes > 0) {
        return 'Atualizado há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
      } else {
        return 'Atualizado agora';
      }
    } catch (e) {
      return 'Data desconhecida';
    }
  }
}