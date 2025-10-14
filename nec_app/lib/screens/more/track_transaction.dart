import 'package:flutter/material.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'package:nec_app/widgets/cards/track_transaction_widget.dart';

class TrackTransactionScreen extends StatelessWidget {
  const TrackTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Track Transaction',
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
            children: const [
              TrackTransactionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}


