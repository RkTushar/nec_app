import 'package:flutter/material.dart';
import 'package:nec_app/widgets/buttons/whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/buttons/primary_button.dart';
import 'package:nec_app/widgets/converters/send_recieve_converter.dart';
import 'package:nec_app/widgets/buttons/notification_button.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button_2.dart';
import 'package:nec_app/widgets/cards/transaction_card.dart';
import 'package:nec_app/widgets/cards/rating_card.dart';
import 'package:nec_app/screens/send/send_screen.dart';
import 'package:nec_app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String? initialSenderCurrency;
  final double? initialAmount;
  const HomeScreen({super.key, this.initialSenderCurrency, this.initialAmount});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _currentCurrency;

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    // Use initialSenderCurrency if provided, otherwise load from SharedPreferences
    if (widget.initialSenderCurrency != null && widget.initialSenderCurrency!.isNotEmpty) {
      setState(() => _currentCurrency = widget.initialSenderCurrency);
      // Save to SharedPreferences for future use
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_sender_currency_code', widget.initialSenderCurrency!);
    } else {
      // Load from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedCurrency = prefs.getString('last_sender_currency_code');
      setState(() => _currentCurrency = savedCurrency ?? 'GBP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).colorScheme.primary;
    // Symbol remains available via SharedPreferences for other screens; no need to pass here.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _HeaderCard(primaryGreen: primaryGreen, notificationCount: 0),
                const SizedBox(height: 20),
                const RatingCard(),
                _InviteRow(primaryGreen: primaryGreen, currencyCode: _currentCurrency),
                const SizedBox(height: 12),
                Container(
                  // Remove card look; blend with background (dropdown remains white inside widget)
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: SendReceiveConverter(
                    initialSenderCurrency: _currentCurrency,
                    initialAmount: widget.initialAmount,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Recipients get an extra 2.5%',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SendScreen(showNavBar: false),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text('Recent transactions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                // Show last 5 recent transactions
                ...TransactionModel.getRecentTransactions().map((transaction) => 
                  TransactionCard(
                    name: transaction.name,
                    statusText: transaction.statusText,
                    amountText: transaction.formattedAmount,
                    dateText: transaction.formattedDate,
                    highlighted: transaction.highlighted,
                    onTap: () {
                      // Handle transaction tap - navigate to details
                      print('Tapped recent transaction: ${transaction.name}');
                    },
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 16,
            bottom: 100, // keep above bottom bar
            child: WhatsAppButton(size: 54),
          ),
          ], 
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const NavBar(selectedTab: NavTab.home),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Color primaryGreen;
  final int notificationCount;
  const _HeaderCard({required this.primaryGreen, this.notificationCount = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(
              'assets/icons/profile_icon.svg',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hello!', style: TextStyle(fontSize: 13)),
                SizedBox(height: 2),
                Text('Kamal Ahmed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('NGB76121', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          NotificationButton(
            count: notificationCount,
            backgroundColor: primaryGreen,
            // Use default navigation in the widget
          ),
        ],
      ),
    );
  }
}

class _InviteRow extends StatelessWidget {
  final Color primaryGreen;
  final String? currencyCode;
  const _InviteRow({required this.primaryGreen, this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InviteButton(
          onPressed: () {},
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
        ),
        const SizedBox(width: 8),
        const Text('& Get', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        const SizedBox(width: 8),
        InviteButton2(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          currencyCode: currencyCode,
        ),
      ],
    );
  }
}


