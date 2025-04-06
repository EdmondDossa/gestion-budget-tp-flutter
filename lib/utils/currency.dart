final class CurrencyUtils {
  static double convertToUSD(double amount, double exchangeRate) {
    return amount * exchangeRate;
  }

  static double convertFromUSD(double amount, double exchangeRate) {
    return amount / exchangeRate;
  }

  static String formatCurrency(double amount, {String symbol = '\$', int decimalPlaces = 2}) {
    return '$symbol${amount.toStringAsFixed(decimalPlaces)}';
  }

  static String formatCurrencyWithSymbol(double amount, {String symbol = '\$', int decimalPlaces = 2}) {
    return '$symbol${amount.toStringAsFixed(decimalPlaces)}';
  }

  static String formatCurrencyWithoutSymbol(double amount, {int decimalPlaces = 2}) {
    return amount.toStringAsFixed(decimalPlaces);
  }

  static String formatCurrencyWithCommas(double amount, {String symbol = '\$', int decimalPlaces = 2}) {
    final String formattedAmount = amount.toStringAsFixed(decimalPlaces);
    final RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    final String withCommas = formattedAmount.replaceAllMapped(regExp, (Match match) => '${match[1]},');
    return '$symbol$withCommas';
  }

  static String formatCurrencyWithCommasAndSymbol(double amount, {String symbol = '\$', int decimalPlaces = 2}) {
    final String formattedAmount = amount.toStringAsFixed(decimalPlaces);
    final RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    final String withCommas = formattedAmount.replaceAllMapped(regExp, (Match match) => '${match[1]},');
    return '$symbol$withCommas';
  }

  static String formatCurrencyWithCommasWithoutSymbol(double amount, {int decimalPlaces = 2}) {
    final String formattedAmount = amount.toStringAsFixed(decimalPlaces);
    final RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    final String withCommas = formattedAmount.replaceAllMapped(regExp, (Match match) => '${match[1]},');
    return withCommas;
  }

}