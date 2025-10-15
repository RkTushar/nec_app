import 'bank_model.dart';
import 'country_model.dart';

/// Types of relationship a sender has with the receiver
enum RelationshipType {
  businessContract,
  mother,
  father,
  spouse,
  sibling,
  friend,
  other,
}

extension RelationshipTypeLabel on RelationshipType {
  String get label {
    switch (this) {
      case RelationshipType.businessContract:
        return 'BUSINESS CONTRACT';
      case RelationshipType.mother:
        return 'MOTHER';
      case RelationshipType.father:
        return 'FATHER';
      case RelationshipType.spouse:
        return 'SPOUSE';
      case RelationshipType.sibling:
        return 'SIBLING';
      case RelationshipType.friend:
        return 'FRIEND';
      case RelationshipType.other:
        return 'OTHER';
    }
  }
}

/// Supported bank account types
enum AccountType { savings, current, checking, business }

extension AccountTypeLabel on AccountType {
  String get label {
    switch (this) {
      case AccountType.savings:
        return 'SAVINGS';
      case AccountType.current:
        return 'CURRENT';
      case AccountType.checking:
        return 'CHECKING';
      case AccountType.business:
        return 'BUSINESS';
    }
  }
}

/// Receiver/contact model for saved transfer recipients
class Receiver {
  final String firstName;
  final String lastName;
  final RelationshipType relationship;
  final String phoneNumber;
  final Country country; // receiver's country
  final Bank bank; // see bank_model.dart
  final AccountType accountType;
  final String accountNumber;
  final String bankCity; // which city
  final String branchName; // branch within the selected city

  const Receiver({
    required this.firstName,
    required this.lastName,
    required this.relationship,
    required this.phoneNumber,
    required this.country,
    required this.bank,
    required this.accountType,
    required this.accountNumber,
    required this.bankCity,
    required this.branchName,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      relationship: RelationshipType.values.firstWhere(
        (r) => r.name == (json['relationship'] as String?),
        orElse: () => RelationshipType.other,
      ),
      phoneNumber: json['phoneNumber'] as String? ?? '',
      country: CountryRepository.byCode(json['countryCode'] as String? ?? 'BD') ??
          CountryRepository.getAll().first,
      bank: Bank(name: json['bankName'] as String? ?? ''),
      accountType: AccountType.values.firstWhere(
        (a) => a.name == (json['accountType'] as String?),
        orElse: () => AccountType.savings,
      ),
      accountNumber: json['accountNumber'] as String? ?? '',
      bankCity: json['bankCity'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'relationship': relationship.name,
        'phoneNumber': phoneNumber,
        'countryCode': country.code,
        'bankName': bank.name,
        'accountType': accountType.name,
        'accountNumber': accountNumber,
        'bankCity': bankCity,
        'branchName': branchName,
      };
}

/// Example set of cities and branches for demo purposes
class DemoBankGeography {
  static const List<String> cities = <String>[
    'Dhaka',
    'Chattogram',
    'Sylhet',
    'Rajshahi',
  ];

  static const Map<String, List<String>> cityToBranches = <String, List<String>>{
    'Dhaka': <String>['Gulshan', 'Dhanmondi', 'Motijheel'],
    'Chattogram': <String>['Agrabad', 'Pahartali'],
    'Sylhet': <String>['Zindabazar', 'Amberkhana'],
    'Rajshahi': <String>['Shaheb Bazar', 'Uposhohor'],
  };
}

/// Centralized demo receivers used across the app (seed data)
class DemoReceivers {
  static final List<Receiver> list = <Receiver>[
    Receiver(
      firstName: 'TEST',
      lastName: 'AC',
      relationship: RelationshipType.businessContract,
      phoneNumber: '01811445577',
      country: CountryRepository.byCode('BD')!,
      bank: Bank.demoBanks[0], // TRUST BANK LTD
      accountType: AccountType.savings,
      accountNumber: '82451475524521',
      bankCity: 'Dhaka',
      branchName: 'Gulshan',
    ),
    Receiver(
      firstName: 'Rafi',
      lastName: 'Ahmed',
      relationship: RelationshipType.friend,
      phoneNumber: '01700111222',
      country: CountryRepository.byCode('BD')!,
      bank: Bank.demoBanks[1], // DUTCH-BANGLA BANK
      accountType: AccountType.current,
      accountNumber: '0123456789012',
      bankCity: 'Chattogram',
      branchName: 'Agrabad',
    ),
    Receiver(
      firstName: 'Sadia',
      lastName: 'Khan',
      relationship: RelationshipType.sibling,
      phoneNumber: '01633445566',
      country: CountryRepository.byCode('BD')!,
      bank: Bank.demoBanks[3], // BRAC BANK
      accountType: AccountType.savings,
      accountNumber: '998877665544',
      bankCity: 'Sylhet',
      branchName: 'Zindabazar',
    ),
    Receiver(
      firstName: 'Hasan',
      lastName: 'Ali',
      relationship: RelationshipType.father,
      phoneNumber: '01555666777',
      country: CountryRepository.byCode('BD')!,
      bank: Bank.demoBanks[5], // SONALI BANK
      accountType: AccountType.checking,
      accountNumber: '556677889900',
      bankCity: 'Rajshahi',
      branchName: 'Shaheb Bazar',
    ),
  ];
}


