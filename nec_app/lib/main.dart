import 'package:flutter/material.dart';
import 'package:nec_app/screens/auth/auth_choose.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nec Money Mobile',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F8F8),
          elevation: 0,
        ),
      ),
      home: const AuthChoose(),
    );
  }
}
