class TransactionModel {
  final String id;
  final String name;
  final String status;
  final double amount; // receiver amount in local currency (e.g., BDT)
  final DateTime date;
  final bool highlighted;

  // Additional detail fields for transaction details UI
  final String transactionNumber;
  final String receiverCurrency; // e.g., 'BDT'
  final double transferAmountGbp;
  final double usedBalanceGbp;
  final double paymentAmountGbp;
  final double cardChargeGbp;
  final double transferFeeGbp;
  final String paymentStatusText; // e.g., 'In Hold (Mobile).'
  final String bankName;

  TransactionModel({
    required this.id,
    required this.name,
    required this.status,
    required this.amount,
    required this.date,
    this.highlighted = false,
    required this.transactionNumber,
    this.receiverCurrency = 'BDT',
    required this.transferAmountGbp,
    this.usedBalanceGbp = 0.0,
    required this.paymentAmountGbp,
    this.cardChargeGbp = 0.0,
    this.transferFeeGbp = 0.0,
    this.paymentStatusText = 'In Hold (Mobile).',
    this.bankName = 'TRUST BANK LTD',
  });

  // Helper method to format amount as currency
  String get formattedAmount => '$receiverCurrency ${amount.toStringAsFixed(2)}';

  // Helper method to format date
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year.toString().substring(2);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$day-$month-$year ${hour == 0 ? 12 : hour}:$minute $period';
  }

  // Helper method to get status text
  String get statusText => 'Status : $status';

  String get formattedIssueDate =>
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  String get formattedIssueTime {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:$minute:$second $period';
  }

  // 10 Demo transactions
  static List<TransactionModel> getDemoTransactions() {
    // Demo pool of bank names
    const List<String> demoBanks = <String>[
      'TRUST BANK LTD',
      'DUTCH-BANGLA BANK',
      'STANDARD CHARTERED',
      'BRAC BANK',
      'EASTERN BANK LTD',
      'SONALI BANK',
      'HABIB BANK',
      'NATIONAL BANK LTD',
    ];
    String bank(int i) => demoBanks[i % demoBanks.length];
    return [
      TransactionModel(
        id: '1',
        name: 'John Doe',
        status: 'Done',
        amount: 15000.00,
        date: DateTime(2025, 09, 8, 14, 30, 5),
        highlighted: false,
        transactionNumber: 'GB2537629/000001',
        transferAmountGbp: 5.00,
        paymentAmountGbp: 5.00,
        bankName: bank(0),
      ),
      TransactionModel(
        id: '2',
        name: 'Jane Smith',
        status: 'Cancelled',
        amount: 8500.00,
        date: DateTime(2024, 11, 7, 16, 45, 12),
        highlighted: true,
        transactionNumber: 'GB2537629/000002',
        transferAmountGbp: 12.50,
        paymentAmountGbp: 12.50,
        bankName: bank(1),
      ),
      TransactionModel(
        id: '3',
        name: 'Mike Johnson',
        status: 'Done',
        amount: 12000.00,
        date: DateTime(2024, 11, 6, 10, 15, 55),
        highlighted: false,
        transactionNumber: 'GB2537629/000003',
        transferAmountGbp: 9.75,
        paymentAmountGbp: 9.75,
        bankName: bank(2),
      ),
      TransactionModel(
        id: '4',
        name: 'Sarah Wilson',
        status: 'Cancelled',
        amount: 9500.00,
        date: DateTime(2024, 11, 5, 18, 20, 33),
        highlighted: false,
        transactionNumber: 'GB2537629/000004',
        transferAmountGbp: 7.00,
        paymentAmountGbp: 7.00,
        bankName: bank(3),
      ),
      TransactionModel(
        id: '5',
        name: 'David Brown',
        status: 'Done',
        amount: 18000.00,
        date: DateTime(2024, 11, 4, 12, 30, 11),
        highlighted: false,
        transactionNumber: 'GB2537629/000005',
        transferAmountGbp: 15.25,
        paymentAmountGbp: 15.25,
        bankName: bank(4),
      ),
      TransactionModel(
        id: '6',
        name: 'Lisa Davis',
        status: 'Cancelled',
        amount: 7200.00,
        date: DateTime(2024, 11, 3, 15, 45, 42),
        highlighted: true,
        transactionNumber: 'GB2537629/000006',
        transferAmountGbp: 6.25,
        paymentAmountGbp: 6.25,
        bankName: bank(5),
      ),
      TransactionModel(
        id: '7',
        name: 'Robert Miller',
        status: 'Done',
        amount: 13500.00,
        date: DateTime(2024, 11, 2, 09, 20, 2),
        highlighted: false,
        transactionNumber: 'GB2537629/000007',
        transferAmountGbp: 11.80,
        paymentAmountGbp: 11.80,
        bankName: bank(6),
      ),
      TransactionModel(
        id: '8',
        name: 'Emily Garcia',
        status: 'Cancelled',
        amount: 6800.00,
        date: DateTime(2024, 11, 1, 20, 10, 27),
        highlighted: false,
        transactionNumber: 'GB2537629/000008',
        transferAmountGbp: 4.75,
        paymentAmountGbp: 4.75,
        bankName: bank(7),
      ),
      TransactionModel(
        id: '9',
        name: 'Michael Chen',
        status: 'Done',
        amount: 22000.00,
        date: DateTime(2024, 10, 31, 11, 35, 49),
        highlighted: false,
        transactionNumber: 'GB2537629/000009',
        transferAmountGbp: 18.90,
        paymentAmountGbp: 18.90,
        bankName: bank(8),
      ),
      TransactionModel(
        id: '10',
        name: 'Anna Taylor',
        status: 'Cancelled',
        amount: 10500.00,
        date: DateTime(2024, 10, 30, 17, 25, 7),
        highlighted: true,
        transactionNumber: 'GB2537629/000010',
        transferAmountGbp: 8.40,
        paymentAmountGbp: 8.40,
        bankName: bank(9),
      ),
    ];
  }

  // Get last 5 recent transactions (most recent first)
  static List<TransactionModel> getRecentTransactions() {
    final allTransactions = getDemoTransactions();
    // Sort by date descending (most recent first) and take first 5
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions.take(5).toList();
  }
}