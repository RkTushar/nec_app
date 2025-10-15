class Bank {
  final String name;

  const Bank({required this.name});

  // Centralized demo bank names used across the app
  static const List<String> demoBankNames = <String>[
    'TRUST BANK LTD',
    'DUTCH-BANGLA BANK',
    'STANDARD CHARTERED',
    'BRAC BANK',
    'EASTERN BANK LTD',
    'SONALI BANK',
    'HABIB BANK',
    'NATIONAL BANK LTD',
  ];

  // Convenience accessor that safely wraps the index within bounds
  static String nameAt(int index) {
    if (demoBankNames.isEmpty) return '';
    final int safeIndex = index % demoBankNames.length;
    return demoBankNames[safeIndex];
  }
}


