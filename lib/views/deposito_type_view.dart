import 'package:flutter/material.dart';

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
        onPressed: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Deposito Type',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Name',
                                  ),
                                ),

                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Interest Rate',
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
                  IconButton(
                      onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                              heightFactor: 0.50,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Header row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Edit Deposito Type',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),

                                    Expanded(
                                      child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                decoration: const InputDecoration(
                                                  border: UnderlineInputBorder(),
                                                  labelText: 'Name',
                                                ),
                                              ),

                                              TextFormField(
                                                decoration: const InputDecoration(
                                                  border: UnderlineInputBorder(),
                                                  labelText: 'Interest Rate',
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Save'),
                                          ),
                                        ),

                                        const SizedBox(width: 12.0),

                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () async {
                                              final bool? confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Confirm Delete'),
                                                    content: const Text('Are you sure you want to delete this item?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, false), // cancel
                                                        child: const Text('Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.red,
                                                          foregroundColor: Colors.white,
                                                        ),
                                                        onPressed: () => Navigator.pop(context, true), // confirm
                                                        child: const Text('Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              if (confirm == true) {
                                                // Proceed with deletion logic here
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Item deleted')),
                                                );

                                                Navigator.of(context).pop();
                                              }
                                            },

                                            child: const Text('Delete'),
                                          ),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}