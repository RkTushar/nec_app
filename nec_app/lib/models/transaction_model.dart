class TransactionModel {
  final String id;
  final String name;
  final String status;
  final double amount;
  final DateTime date;
  final bool highlighted;

  TransactionModel({
    required this.id,
    required this.name,
    required this.status,
    required this.amount,
    required this.date,
    this.highlighted = false,
  });

  // Helper method to format amount as currency
  String get formattedAmount => 'BDT ${amount.toStringAsFixed(2)}';

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

  // 10 Demo transactions
  static List<TransactionModel> getDemoTransactions() {
    return [
      TransactionModel(
        id: '1',
        name: 'John Doe',
        status: 'Done',
        amount: 15000.00,
        date: DateTime(2025, 09, 8, 14, 30),
        highlighted: false,
      ),
      TransactionModel(
        id: '2',
        name: 'Jane Smith',
        status: 'Cancelled',
        amount: 8500.00,
        date: DateTime(2024, 11, 7, 16, 45),
        highlighted: true,
      ),
      TransactionModel(
        id: '3',
        name: 'Mike Johnson',
        status: 'Done',
        amount: 12000.00,
        date: DateTime(2024, 11, 6, 10, 15),
        highlighted: false,
      ),
      TransactionModel(
        id: '4',
        name: 'Sarah Wilson',
        status: 'Cancelled',
        amount: 9500.00,
        date: DateTime(2024, 11, 5, 18, 20),
        highlighted: false,
      ),
      TransactionModel(
        id: '5',
        name: 'David Brown',
        status: 'Done',
        amount: 18000.00,
        date: DateTime(2024, 11, 4, 12, 30),
        highlighted: false,
      ),
      TransactionModel(
        id: '6',
        name: 'Lisa Davis',
        status: 'Cancelled',
        amount: 7200.00,
        date: DateTime(2024, 11, 3, 15, 45),
        highlighted: true,
      ),
      TransactionModel(
        id: '7',
        name: 'Robert Miller',
        status: 'Done',
        amount: 13500.00,
        date: DateTime(2024, 11, 2, 09, 20),
        highlighted: false,
      ),
      TransactionModel(
        id: '8',
        name: 'Emily Garcia',
        status: 'Cancelled',
        amount: 6800.00,
        date: DateTime(2024, 11, 1, 20, 10),
        highlighted: false,
      ),
      TransactionModel(
        id: '9',
        name: 'Michael Chen',
        status: 'Done',
        amount: 22000.00,
        date: DateTime(2024, 10, 31, 11, 35),
        highlighted: false,
      ),
      TransactionModel(
        id: '10',
        name: 'Anna Taylor',
        status: 'Cancelled',
        amount: 10500.00,
        date: DateTime(2024, 10, 30, 17, 25),
        highlighted: true,
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