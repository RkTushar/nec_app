import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/widgets/buttons/primary_button.dart';
import 'package:nec_app/widgets/cards/common_card.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'package:nec_app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nec_app/widgets/cards/track_transaction_widget.dart';

/// Demo screen: Track transaction (read-only mock) built with existing widgets
class TrackTransactionDemoScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const TrackTransactionDemoScreen({super.key, this.transaction});

  @override
  State<TrackTransactionDemoScreen> createState() => _TrackTransactionDemoScreenState();
}

class _TrackTransactionDemoScreenState extends State<TrackTransactionDemoScreen> {
  String _senderCurrency = 'GBP';
  bool _isDownloading = false; // State variable to track downloading status

  @override
  void initState() {
    super.initState();
    _loadSenderCurrency();
  }

  Future<void> _loadSenderCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String code = prefs.getString('last_sender_currency_code') ?? 'GBP';
    if (!mounted) return;
    setState(() => _senderCurrency = code);
  }

  // A mock function to simulate a download process
  Future<void> _handleDownloadReceipt() async {
    if (_isDownloading) return; // Prevent multiple taps

    setState(() {
      _isDownloading = true; // Set state to "downloading"
    });

    // Simulate an API call or file download
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isDownloading = false; // Set state back to "not downloading"
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Track transaction',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track your transaction by entering your transaction\nnumber, which you\'ll find in your invoice sent to the\nemail.',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              TrackTransactionWidget(
                onTrack: (String transactionNumber) {
                  // Hook for track action if needed
                },
              ),
              const SizedBox(height: 24),
              // Transaction details card
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15), // Add padding to make space for the header
                    child: CommonCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Icon(Icons.account_balance_wallet_rounded, color: theme.colorScheme.primary, size: 40),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _TitleWithCopy(
                            title: 'Transaction Number',
                            value: widget.transaction?.transactionNumber ?? 'GB2537629/033824',
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Receiver Amount',
                            value: '$_senderCurrency : ${widget.transaction?.amount.toStringAsFixed(2) ?? '808.00'}',
                          ),
                          _DetailRow(label: 'Transfer amount', value: '${(widget.transaction?.transferAmountGbp ?? 5.0).toStringAsFixed(2)} $_senderCurrency'),
                          _DetailRow(label: 'Used Balance', value: '${(widget.transaction?.usedBalanceGbp ?? 0.0).toStringAsFixed(2)} $_senderCurrency'),
                          _DetailRow(label: 'Payment amount', value: '${(widget.transaction?.paymentAmountGbp ?? 5.0).toStringAsFixed(2)} $_senderCurrency'),
                          _DetailRow(label: 'Card charge', value: '${(widget.transaction?.cardChargeGbp ?? 0.0).toStringAsFixed(2)} $_senderCurrency'),
                          _DetailRow(label: 'Transfer amount fee', value: '${(widget.transaction?.transferFeeGbp ?? 0.0).toStringAsFixed(2)} $_senderCurrency'),
                          const SizedBox(height: 8),
                          _DetailRow(label: 'Payment Status', value: widget.transaction?.paymentStatusText ?? 'In Hold (Mobile).'),
                          const SizedBox(height: 8),
                          _DetailRow(label: 'Bank name', value: widget.transaction?.bankName ?? 'TRUST BANK LTD'),
                          const SizedBox(height: 8),
                          _DetailRow(label: 'Issue Date', value: widget.transaction?.formattedIssueDate ?? '11-10-2025'),
                          _DetailRow(label: 'Issue Time', value: widget.transaction?.formattedIssueTime ?? '14:02:05'),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            label: _isDownloading ? 'Downloading...' : 'Download receipt', // Change label based on state
                            onPressed: _handleDownloadReceipt, // Call the new handler function
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: _SectionHeader(title: 'Transaction details', color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TitleWithCopy extends StatelessWidget {
  final String title;
  final String value;

  const _TitleWithCopy({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.copy_outlined, size: 20),
              color: AppColors.textSecondary,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaction number copied')),
                );
              },
              tooltip: 'Copy',
            )
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelLarge?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}