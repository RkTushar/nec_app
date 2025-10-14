import 'package:flutter/material.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/buttons/notification_button.dart';
import 'package:nec_app/widgets/fields/custom_datepicker.dart';
import 'package:nec_app/widgets/cards/transaction_card.dart';
import 'package:nec_app/models/transaction_model.dart';
import 'package:nec_app/models/notification_model.dart';
import 'package:nec_app/theme/theme_data.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  
  // Get demo transactions
  List<TransactionModel> get allTransactions => TransactionModel.getDemoTransactions();
  
  // Get filtered transactions based on date range
  List<TransactionModel> get filteredTransactions {
    if (fromDate == null && toDate == null) {
      return allTransactions;
    }
    
    return allTransactions.where((transaction) {
      bool afterFromDate = fromDate == null || transaction.date.isAfter(fromDate!) || transaction.date.isAtSameMomentAs(fromDate!);
      bool beforeToDate = toDate == null || transaction.date.isBefore(toDate!) || transaction.date.isAtSameMomentAs(toDate!);
      
      return afterFromDate && beforeToDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: NotificationButton(
              count: NotificationModel.getTotalCount(),
              backgroundColor: AppColors.primary,
              iconColor: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          // Date picker section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'From date',
                    date: fromDate,
                    onTap: () => _showDatePicker(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'To date',
                    date: toDate,
                    onTap: () => _showDatePicker(context, false),
                  ),
                ),
              ],
            ),
          ),
          // Transaction list or no data
          Expanded(
            child: filteredTransactions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          fromDate != null || toDate != null
                              ? 'No transactions found for the selected date range.'
                              : 'We have found total ${allTransactions.length} transactions in your history.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return TransactionCard(
                          name: transaction.name,
                          statusText: transaction.statusText,
                          amountText: transaction.formattedAmount,
                          dateText: transaction.formattedDate,
                          highlighted: transaction.highlighted,
                          model: transaction,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const NavBar(selectedTab: NavTab.history),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
                        : 'DD-MM-YYYY',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context, bool isFromDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CustomDatePicker(
          initialDate: isFromDate ? fromDate : toDate,
          onDateSelected: (selectedDate) {
            setState(() {
              if (isFromDate) {
                fromDate = selectedDate;
                // If from date is after to date, clear to date
                if (toDate != null && fromDate!.isAfter(toDate!)) {
                  toDate = null;
                  _showDateValidationMessage(context, 'From date cannot be after To date. To date has been cleared.');
                }
              } else {
                toDate = selectedDate;
                // If to date is before from date, clear from date
                if (fromDate != null && toDate!.isBefore(fromDate!)) {
                  fromDate = null;
                  _showDateValidationMessage(context, 'To date cannot be before From date. From date has been cleared.');
                }
              }
            });
          },
        ),
      ),
    );
  }

  void _showDateValidationMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}


