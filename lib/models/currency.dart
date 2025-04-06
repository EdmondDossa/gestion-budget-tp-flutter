final class CurrencyModel {
  /// ISO 4217 currency code, e.g., "USD", "EUR"
  final String code;

  /// Full currency name, e.g., "United States Dollar"
  final String name;

  /// Currency symbol, e.g., "$", "€", "₦"
  final String symbol;

  /// Number of fraction digits (e.g. 2 for USD, 0 for JPY)
  final int decimalDigits;

  /// Currency's native symbol position
  /// If true, symbol comes before the amount (e.g., $12), else after (e.g., 12€)
  final bool symbolOnLeft;

  /// Whether a space exists between symbol and amount
  final bool spaceBetweenSymbolAndAmount;

  /// Constructor for creating a Currency object
  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalDigits,
    required this.symbolOnLeft,
    required this.spaceBetweenSymbolAndAmount,
  });

  /// Factory constructor to create a Currency object with default values
  factory CurrencyModel.create({
    required String code,
    required String name,
    required String symbol,
    int decimalDigits = 2,
    bool symbolOnLeft = true,
    bool spaceBetweenSymbolAndAmount = false
  }) {
    return CurrencyModel(
      code: code,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
      symbolOnLeft: symbolOnLeft,
      spaceBetweenSymbolAndAmount: spaceBetweenSymbolAndAmount
    );
  }

  /// Factory constructor to update an existing Currency object
  factory CurrencyModel.update({
    required String code,
    required String name,
    required String symbol,
    int decimalDigits = 2,
    bool symbolOnLeft = true,
    bool spaceBetweenSymbolAndAmount = false
  }) {
    return CurrencyModel(
      code: code,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
      symbolOnLeft: symbolOnLeft,
      spaceBetweenSymbolAndAmount: spaceBetweenSymbolAndAmount
    );
  }

  /// Factory constructor to create a Currency object from a map
  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      code: map['code'],
      name: map['name'],
      symbol: map['symbol'],
      decimalDigits: map['decimal_digits'],
      symbolOnLeft: map['symbol_on_left'] == 1,
      spaceBetweenSymbolAndAmount: map['space_between_symbol_and_amount'] == 1
    );
  }

  /// Converts the Currency object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'decimal_digits': decimalDigits,
      'symbol_on_left': symbolOnLeft ? 1 : 0,
      'space_between_symbol_and_amount': spaceBetweenSymbolAndAmount ? 1 : 0
    };
  }

}