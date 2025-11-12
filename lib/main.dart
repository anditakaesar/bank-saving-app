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
      home: const HomePage(title: 'Customers'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

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
          BottomNavigationBarItem(icon: Icon(Icons.type_specimen), label: 'Deposito Types'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onTapMenu,
      ),

      body: _pageOptions[_currentIndex]
    );
  }
}

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  final List<String> _listCustomer = [
    'Andita Kaesar Fahmi name long super long right now okay',
    'Fahmi'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Customers'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),

      body: ListView(
        children: _listCustomer.map((name) {
          return InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(name)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DepositTypePage extends StatelessWidget {
  DepositTypePage({super.key});

  final List<String> _listDeposito = [
    'Bronze 3% p.a.',
    'Silver 5% p.a.',
    'Gold 7% p.a.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Deposito Types'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),

      body: ListView(
        children: _listDeposito.map((name) {
          return InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(name)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

