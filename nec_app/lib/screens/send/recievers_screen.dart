import 'package:flutter/material.dart';
import 'package:nec_app/models/notification_model.dart';
import 'package:nec_app/models/recievers_model.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'package:nec_app/widgets/buttons/notification_button.dart';
import 'package:nec_app/widgets/fields/search_bar.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/cards/receiver_card.dart';
import 'package:nec_app/widgets/buttons/secondary_button.dart';

class ReceiversScreen extends StatefulWidget {
  final bool showNavBar; // when false, hide FAB and Bottom Nav
  const ReceiversScreen({super.key, this.showNavBar = true});

  @override
  State<ReceiversScreen> createState() => _ReceiversScreenState();
}

class _ReceiversScreenState extends State<ReceiversScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  List<Receiver> get _filteredReceivers {
    if (_query.trim().isEmpty) return DemoReceivers.list;
    final String q = _query.toLowerCase();
    return DemoReceivers.list.where((r) {
      final String name = ('${r.firstName} ${r.lastName}').toLowerCase();
      return name.contains(q) || r.phoneNumber.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Ensure no stale search text hides new receivers when navigating back
    _controller.text = '';
    _query = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Force a rebuild when dependencies change so any newly added demo
    // receivers in the model reflect immediately without manual refresh.
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.showNavBar ? null : const AppBackButton(),
        title: const Text(
          'Receivers',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        centerTitle: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: NotificationButton(
              count: NotificationModel.getTotalCount(),
              backgroundColor: AppColors.primary,
            ),
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AppSearchBar(
                  controller: _controller,
                  hintText: 'Search receiver name',
                  onChanged: (v) => setState(() => _query = v),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 160),
                    itemCount: _filteredReceivers.length,
                    itemBuilder: (context, index) {
                      final Receiver r = _filteredReceivers[index];
                      return ReceiverCard(receiver: r);
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: widget.showNavBar ? 100 : 24, // keep above bottom bar if present
              child: SecondaryButton(
                label: 'Add receiver',
                onPressed: () {},
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                borderColor: Colors.transparent,
                height: 44,
                width: 120,
                fontSize: 14,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                borderRadius: const BorderRadius.all(Radius.circular(28)),
                leading: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.showNavBar ? const CustomFloatingActionButton() : null,
      floatingActionButtonLocation: widget.showNavBar ? FloatingActionButtonLocation.centerDocked : null,
      bottomNavigationBar: widget.showNavBar ? const NavBar(selectedTab: null) : null,
    );
  }
}

// Using shared SecondaryButton to keep styling consistent across app

