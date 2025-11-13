import 'package:bank_saving_system/views/homepage_view.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const _mainTitle = 'Bank Saving System';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _mainTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const HomePage(),
    );
  }
}