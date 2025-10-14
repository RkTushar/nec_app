import 'package:flutter/material.dart';
import 'package:nec_app/screens/auth/auth_choose.dart';
import 'package:nec_app/theme/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthChoose(),
    );
  }
}
