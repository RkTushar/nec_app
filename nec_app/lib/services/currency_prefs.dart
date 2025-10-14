import 'package:shared_preferences/shared_preferences.dart';

class CurrencyPrefs {
  CurrencyPrefs._();

  static const String _keyLastSenderCurrency = 'last_sender_currency_code';
  static const String _keyCurrencySymbol = 'currencySymbol';

  static Future<void> saveSenderCurrencyCode(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastSenderCurrency, code);
  }

  static Future<String?> loadSenderCurrencyCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_keyLastSenderCurrency);
    if (code == null || code.trim().isEmpty) return null;
    return code;
  }

  static Future<String> loadSenderCurrencyCodeOrDefault(String fallback) async {
    final String? code = await loadSenderCurrencyCode();
    return (code == null || code.isEmpty) ? fallback : code;
  }

  static Future<void> saveCurrencySymbol(String symbol) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrencySymbol, symbol);
  }

  static Future<String?> loadCurrencySymbol() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? symbol = prefs.getString(_keyCurrencySymbol);
    if (symbol == null || symbol.isEmpty) return null;
    return symbol;
  }
}


