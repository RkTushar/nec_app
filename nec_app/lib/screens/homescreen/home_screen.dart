import 'package:flutter/material.dart';
// import 'package:nec_app/widgets/whatsapp.dart';
import 'package:nec_app/widgets/nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NEC Home'), centerTitle: true),
      body: const Center(child: Text('Home content coming soon')),
      floatingActionButton: CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavBar(),
      // Quick WhatsApp access anchored at bottom-right
      persistentFooterButtons: const [SizedBox.shrink()],
    );
  }
}
