import 'package:bank_saving_system/controllers/deposit_type_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectDepositTypePage extends StatefulWidget {
  const SelectDepositTypePage({super.key});

  @override
  State<SelectDepositTypePage> createState() => _SelectDepositTypePageState();
}

class _SelectDepositTypePageState extends State<SelectDepositTypePage> {
  final ScrollController _scrollController = ScrollController();

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();

    final controller = Provider.of<DepositTypeController>(
      context,
      listen: false,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !controller.isLoading &&
          controller.hasMore) {
        controller.fetchNext();
      }
    });

    Future.microtask(() {
      controller.fetchDepositTypes();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DepositTypeController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Select Deposit Type'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == null) return;
          final selected = controller.deposittypes[_selectedIndex!];
          Navigator.pop(context, selected);
        },
        child: const Icon(Icons.check),
      ),

      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 100.0, top: 10.0),
        itemCount:
            controller.deposittypes.length + (controller.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.deposittypes.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final depositType = controller.deposittypes[index];
          final selected = _selectedIndex == index;

          return ListTile(
            onTap: () {
              setState(() => _selectedIndex = index);
            },
            leading: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
            ),
            tileColor: selected
                ? Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2)
                : null,
            title: Text(
              '${depositType.name} (${depositType.annualInterestRate}% p.a.)',
            ),
          );
        },
      ),
    );
  }
}
