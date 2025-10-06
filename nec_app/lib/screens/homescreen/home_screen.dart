import 'package:flutter/material.dart';
import 'package:nec_app/widgets/whatsapp.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/primary_button.dart';
import 'package:nec_app/widgets/select_country_widget.dart';
import 'package:nec_app/widgets/converter_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF19A250);
    return Scaffold(
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
                _HeaderCard(primaryGreen: primaryGreen),
                const SizedBox(height: 12),
                _InviteRow(primaryGreen: primaryGreen),
                const SizedBox(height: 12),
                _CountrySelector(),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: const ConverterWidget(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Recipients get an extra 2.5%',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(label: 'Continue', onPressed: () {}),
                const SizedBox(height: 16),
                const Text('Recent transactions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                _TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 10,000.00',
                  dateText: '06-Nov-24 10:10 PM',
                  highlighted: false,
                ),
                const SizedBox(height: 8),
                _TransactionCard(
                  name: 'Badri',
                  statusText: 'Status : Cancelled',
                  amountText: 'BDT 10,000.00',
                  dateText: '06-Nov-24 10:10 PM',
                  highlighted: true,
                ),
              ],
            ),
          ),
          // WhatsApp support button
          Positioned(
            right: 16,
            bottom: 100, // keep above bottom bar
            child: const WhatsAppButton(size: 54),
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
  const _HeaderCard({required this.primaryGreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hello!', style: TextStyle(fontSize: 13, color: Colors.black54)),
                SizedBox(height: 2),
                Text('Kamal Ahmed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('NGB76121', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Icon(Icons.notifications_none_rounded, size: 28, color: Colors.black87),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                ),
              ),
            ],
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
        SizedBox(
          width: 140,
          height: 33,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Invite', style: TextStyle(fontWeight: FontWeight.w800)),
                  SizedBox(width: 6),
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset('assets/images/person_add_icon.png', width: 20, height: 20),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(width: 8),
        const Text('& Get', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        const SizedBox(width: 8),
        SizedBox(
          width: 73,
          height: 33,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(73, 33),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('£5', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(width: 4),
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset('assets/images/gift_icon.png', width: 20, height: 20),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CountrySelector extends StatefulWidget {
  @override
  State<_CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<_CountrySelector> {
  Map<String, String>? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SelectCountryField(
          selectedCountryData: _selected,
          initialCountryCode: 'GB',
          onChanged: (v) => setState(() => _selected = v),
        ),
        const SizedBox(height: 6),
        const Text('£1.00 = BDT 164.50', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String name;
  final String statusText;
  final String amountText;
  final String dateText;
  final bool highlighted;

  const _TransactionCard({
    required this.name,
    required this.statusText,
    required this.amountText,
    required this.dateText,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted ? const Color(0xFF1E88E5) : Colors.grey.shade300,
          width: highlighted ? 2 : 1,
        ),
        boxShadow: highlighted
            ? <BoxShadow>[BoxShadow(color: const Color(0xFF1E88E5).withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))]
            : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal, width: 2),
            ),
            child: const Icon(Icons.person_outline, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Status : Cancelled', style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(dateText, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 6),
              Text(amountText, style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w800)),
            ],
          )
        ],
      ),
    );
  }
}
