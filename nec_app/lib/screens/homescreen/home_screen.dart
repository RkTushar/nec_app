import 'package:flutter/material.dart';
import 'package:nec_app/widgets/whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/primary_button.dart';
import 'package:nec_app/widgets/secondary_button.dart';
import 'package:nec_app/widgets/send_recieve_converter.dart';
import 'package:nec_app/widgets/notification_button.dart';
import 'package:nec_app/widgets/transaction_card.dart';

class HomeScreen extends StatelessWidget {
  final String? initialSenderCurrency;
  final double? initialAmount;
  const HomeScreen({super.key, this.initialSenderCurrency, this.initialAmount});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).colorScheme.primary;
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
                _InviteRow(primaryGreen: primaryGreen),
                const SizedBox(height: 12),
                Container(
                  // Remove card look; blend with background (dropdown remains white inside widget)
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: SendReceiveConverter(
                    initialSenderCurrency: initialSenderCurrency,
                    initialAmount: initialAmount,
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
                PrimaryButton(label: 'Continue', onPressed: () {}),
                const SizedBox(height: 16),
                const Text('Recent transactions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 10,000.00',
                  dateText: '06-Nov-24 10:10 PM',
                  highlighted: false,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 10,000.00',
                  dateText: '06-Nov-24 10:10 PM',
                  highlighted: true,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 8,500.00',
                  dateText: '05-Nov-24 08:45 PM',
                  highlighted: false,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 12,300.00',
                  dateText: '04-Nov-24 07:20 PM',
                  highlighted: true,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 9,750.00',
                  dateText: '03-Nov-24 06:05 PM',
                  highlighted: false,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 15,000.00',
                  dateText: '02-Nov-24 05:30 PM',
                  highlighted: true,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 6,420.00',
                  dateText: '01-Nov-24 04:15 PM',
                  highlighted: false,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 11,110.00',
                  dateText: '31-Oct-24 03:00 PM',
                  highlighted: true,
                ),
                const SizedBox(height: 8),
                TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 7,300.00',
                  dateText: '30-Oct-24 01:45 PM',
                  highlighted: false,
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
      bottomNavigationBar: const NavBar(),
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
            onTap: () { debugPrint('Notifications tapped'); },
          ),
        ],
      ),
    );
  }
}

class _InviteRow extends StatelessWidget {
  final Color primaryGreen;
  const _InviteRow({required this.primaryGreen});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SecondaryButton(
          label: 'Invite',
          onPressed: () {},
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          height: 33,
          width: 140,
          trailing: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset('assets/icons/person_add_icon.png', width: 20, height: 20),
          ),
        ),
        const SizedBox(width: 8),
        const Text('& Get', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        const SizedBox(width: 8),
        SecondaryButton(
          label: '£5',
          onPressed: () {},
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          height: 33,
          width: 73,
          trailing: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset('assets/icons/gift_icon.png', width: 20, height: 20),
          ),
        ),
      ],
    );
  }
}


