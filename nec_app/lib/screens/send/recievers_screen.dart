import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/models/notification_model.dart';
import 'package:nec_app/models/recievers_model.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'package:nec_app/widgets/buttons/notification_button.dart';
import 'package:nec_app/widgets/fields/search_bar.dart';
import 'package:nec_app/widgets/nav_bar.dart';
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
                      return _ReceiverCard(receiver: r);
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
                width: 115,
                fontSize: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

class _ReceiverCard extends StatelessWidget {
  final Receiver receiver;
  const _ReceiverCard({required this.receiver});

  @override
  Widget build(BuildContext context) {
    final Color labelColor = AppColors.textSecondary;
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Color(0x0F000000), blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/person_icon.svg',
                          width: 28,
                          height: 28,
                          colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${receiver.firstName.toUpperCase()} ${receiver.lastName.toUpperCase()}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(receiver.phoneNumber, style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 10),
                          _dotLine(' ${receiver.bank.name.toUpperCase()} (ACCOUNT CREDIT)', labelColor),
                          const SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                              Text('ACCOUNT PAYEE', style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              _greenDot(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(receiver.bank.name.toUpperCase(),
                                    style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w700),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(receiver.country.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const <Widget>[
                        Text('EDIT', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                        SizedBox(height: 36),
                        Text('ACTIVE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Add receiver pill over the last card? We want a sticky bottom-right; handled at page level below using Positioned.
      ],
    );
  }

  static Widget _greenDot() => const CircleAvatar(radius: 4, backgroundColor: AppColors.success);

  static Widget _dotLine(String text, Color labelColor) {
    return Row(
      children: <Widget>[
        _greenDot(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.trim(),
            style: TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Using shared SecondaryButton to keep styling consistent across app

