class Utils {
  static final RegExp _thousands = RegExp(r'\B(?=(\d{3})+(?!\d))');

  static String formatPrice(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAll(_thousands, ',');
    return '\$$whole.${parts[1]}';
  }

  static String greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning,';
    if (now.hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}
