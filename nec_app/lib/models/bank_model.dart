class Bank {
  final String name;
  final String? logoAsset; // e.g., 'assets/images/banks/trust_bank.png'

  const Bank({required this.name, this.logoAsset});

  // Centralized demo banks used across the app (name + optional logo)
  static const List<Bank> demoBanks = <Bank>[
    Bank(name: 'TRUST BANK LTD', logoAsset: null),
    Bank(name: 'DUTCH-BANGLA BANK', logoAsset: null),
    Bank(name: 'STANDARD CHARTERED', logoAsset: null),
    Bank(name: 'BRAC BANK', logoAsset: null),
    Bank(name: 'EASTERN BANK LTD', logoAsset: null),
    Bank(name: 'SONALI BANK', logoAsset: null),
    Bank(name: 'HABIB BANK', logoAsset: null),
    Bank(name: 'NATIONAL BANK LTD', logoAsset: null),
  ];

  // Backwards-compatible names list (kept for existing usages)
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

  // Convenience accessors that safely wrap index within bounds
  static String nameAt(int index) {
    if (demoBankNames.isEmpty) return '';
    final int safeIndex = index % demoBankNames.length;
    return demoBankNames[safeIndex];
  }

  static String? logoAt(int index) {
    if (demoBanks.isEmpty) return null;
    final int safeIndex = index % demoBanks.length;
    return demoBanks[safeIndex].logoAsset;
  }
}


