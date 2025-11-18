import 'package:bank_saving_system/views/customer_view.dart';
import 'package:bank_saving_system/views/deposit_type_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static final List<Widget> _pageOptions = <Widget>[
    CustomerPage(),
    DepositTypePage(),
  ];

  void _onTapMenu(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.type_specimen),
            label: 'Deposit Types',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onTapMenu,
      ),

      body: _pageOptions[_currentIndex],
    );
  }
}
