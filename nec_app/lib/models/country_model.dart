class Country {
  final String code; // ISO 3166-1 alpha-2 code, e.g. "ZA"
  final String name; // Localized common name, e.g. "South Africa"
  final String flag; // Emoji flag, e.g. "🇿🇦"
  final String dial; // Country calling code without '+', e.g. "27"
  final String currencyCode; // ISO 4217, e.g. "ZAR"
  final String currencySymbol; // e.g. "R", "$", "£"

  const Country({
    required this.code,
    required this.name,
    required this.flag,
    required this.dial,
    required this.currencyCode,
    required this.currencySymbol,
  });

  Map<String, String> toMap() => <String, String>{
        'code': code,
        'name': name,
        'flag': flag,
        'dial': dial,
        'currency': currencyCode,
        'currencySymbol': currencySymbol,
      };
}

class CountryRepository {
  CountryRepository._();

  static final List<Country> _countries = <Country>[
    const Country(code: 'GB', name: 'United Kingdom', flag: '🇬🇧', dial: '44', currencyCode: 'GBP', currencySymbol: '£'),
    const Country(code: 'US', name: 'United States', flag: '🇺🇸', dial: '1', currencyCode: 'USD', currencySymbol: r'$'),
    const Country(code: 'ZA', name: 'South Africa', flag: '🇿🇦', dial: '27', currencyCode: 'ZAR', currencySymbol: 'R'),
    const Country(code: 'IN', name: 'India', flag: '🇮🇳', dial: '91', currencyCode: 'INR', currencySymbol: '₹'),
    const Country(code: 'JP', name: 'Japan', flag: '🇯🇵', dial: '81', currencyCode: 'JPY', currencySymbol: '¥'),
    const Country(code: 'BD', name: 'Bangladesh', flag: '🇧🇩', dial: '880', currencyCode: 'BDT', currencySymbol: '৳'),
    const Country(code: 'PK', name: 'Pakistan', flag: '🇵🇰', dial: '92', currencyCode: 'PKR', currencySymbol: '₨'),
    const Country(code: 'LK', name: 'Sri Lanka', flag: '🇱🇰', dial: '94', currencyCode: 'LKR', currencySymbol: 'Rs'),
    const Country(code: 'NP', name: 'Nepal', flag: '🇳🇵', dial: '977', currencyCode: 'NPR', currencySymbol: 'Rs'),
    const Country(code: 'NG', name: 'Nigeria', flag: '🇳🇬', dial: '234', currencyCode: 'NGN', currencySymbol: '₦'),
    const Country(code: 'PH', name: 'Philippines', flag: '🇵🇭', dial: '63', currencyCode: 'PHP', currencySymbol: '₱'),
  ];

  static List<Country> getAll() => List<Country>.unmodifiable(_countries);

  static Country? byCode(String code) {
    if (code.trim().isEmpty) return null;
    try {
      return _countries.firstWhere(
        (Country c) => c.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  static Country? byDial(String dial) {
    if (dial.trim().isEmpty) return null;
    try {
      final String normalized = dial.startsWith('+') ? dial.substring(1) : dial;
      return _countries.firstWhere((Country c) => c.dial == normalized);
    } catch (_) {
      return null;
    }
  }
}

class CurrencyRepository {
  CurrencyRepository._();

  // Demo USD-base rates similar to existing widgets for consistent UI.
  static final Map<String, double> _usdBaseRates = <String, double>{
    'USD': 1.0,
    'EUR': 0.93,
    'GBP': 0.81,
    'BDT': 132.00,
    'JPY': 150.0,
    'CAD': 1.36,
    'AUD': 1.50,
    'PKR': 278.00,
    'INR': 84.0,
    'LKR': 305.0,
    'NPR': 134.0,
    'NGN': 1600.0,
    'PHP': 58.0,
    'ZAR': 18.5,
  };

  static final Map<String, String> _currencyFlags = <String, String>{
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'BDT': '🇧🇩',
    'JPY': '🇯🇵',
    'CAD': '🇨🇦',
    'AUD': '🇦🇺',
    'PKR': '🇵🇰',
    'INR': '🇮🇳',
    'LKR': '🇱🇰',
    'NPR': '🇳🇵',
    'NGN': '🇳🇬',
    'PHP': '🇵🇭',
    'ZAR': '🇿🇦',
  };

  static final Map<String, String> _currencySymbols = <String, String>{
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'BDT': 'BDT',
    'JPY': '¥',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'PKR': '₨',
    'INR': '₹',
    'LKR': 'Rs',
    'NPR': 'Rs',
    'NGN': '₦',
    'PHP': '₱',
    'ZAR': 'R',
  };

  static Iterable<String> getSupportedCurrencies() => _usdBaseRates.keys;
  static double? rate(String currency) => _usdBaseRates[currency];
  static String symbol(String currency) => _currencySymbols[currency] ?? currency;
  static String flag(String currency) => _currencyFlags[currency] ?? '';

  static double? convert({required double amount, required String from, required String to}) {
    final double? fr = _usdBaseRates[from];
    final double? tr = _usdBaseRates[to];
    if (fr == null || tr == null) return null;
    return (amount / fr) * tr;
  }

  static double? perOne({required String from, required String to}) {
    final double? fr = _usdBaseRates[from];
    final double? tr = _usdBaseRates[to];
    if (fr == null || tr == null) return null;
    return (1.0 / fr) * tr;
  }

  static List<Country> defaultReceiverCountries() {
    const List<String> codes = <String>['BD', 'PK', 'IN', 'LK', 'NP', 'NG', 'PH'];
    return codes.map((String c) => CountryRepository.byCode(c)).whereType<Country>().toList();
  }
}


