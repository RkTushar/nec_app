import 'package:flutter/material.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';

class ReceiversScreen extends StatelessWidget {
  final bool showNavBar; // when false, hide FAB and Bottom Nav
  const ReceiversScreen({super.key, this.showNavBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showNavBar
            ? null
            : const AppBackButton(),
        title: const Text('Receivers'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Recievers demo screen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: showNavBar ? const CustomFloatingActionButton() : null,
      floatingActionButtonLocation: showNavBar ? FloatingActionButtonLocation.centerDocked : null,
      bottomNavigationBar: showNavBar ? const NavBar(selectedTab: null) : null,
    );
  }
}


