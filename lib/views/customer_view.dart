import 'package:bank_saving_system/controllers/customer_controller.dart';
import 'package:bank_saving_system/models/customer_model.dart';
import 'package:bank_saving_system/views/account_view.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerController _controller = CustomerController();
  final ScrollController _scrollController = ScrollController();

  List<Customer> _customers = [];
  int _page = 1;
  final int _size = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _fetchCustomers();
      }
    });
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customerModel = await _controller.fetchCustomers(
        page: _page,
        size: _size,
      );

      setState(() {
        _customers.addAll(customerModel.customers);
        _isLoading = false;
        _hasMore = customerModel.customers.length == _size;
        if (_hasMore) _page++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load customers: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Customers'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              final TextEditingController _nameController =
                  TextEditingController();

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
                            'Add New Customer',
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
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final newCustomer = await _controller
                                .createCustomer({'name': _nameController.text});

                            setState(() {
                              _customers.add(newCustomer);
                            });

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Customer ${newCustomer.name} created successfully',
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to create customer: $e'),
                              ),
                            );
                          }
                        },
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

      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _customers.clear();
            _page = 1;
            _hasMore = true;
          });
          await _fetchCustomers();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _customers.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _customers.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final customer = _customers[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(title: customer.name),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(customer.name)),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (BuildContext context) {
                            final TextEditingController _editNameController =
                                TextEditingController(text: customer.name);

                            return FractionallySizedBox(
                              heightFactor: 0.50,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Header row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Edit Customer',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),

                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: TextFormField(
                                          controller: _editNameController,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Name',
                                          ),
                                        ),
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                final updatedCustomer =
                                                    await _controller
                                                        .updateCustomer(
                                                          customer.id,
                                                          {
                                                            'name':
                                                                _editNameController
                                                                    .text,
                                                          },
                                                        );

                                                setState(() {
                                                  final index = _customers
                                                      .indexWhere(
                                                        (c) =>
                                                            c.id == customer.id,
                                                      );
                                                  if (index != -1) {
                                                    _customers[index] =
                                                        updatedCustomer;
                                                  }
                                                });

                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Customer ${updatedCustomer.name} updated successfully',
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Failed to update customer: $e',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
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
                                              final bool?
                                              confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Confirm Delete',
                                                    ),
                                                    content: const Text(
                                                      'Are you sure you want to delete this item?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              false,
                                                            ), // cancel
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              true,
                                                            ), // confirm
                                                        child: const Text(
                                                          'Delete',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              if (confirm == true) {
                                                // Proceed with deletion logic here
                                                try {
                                                  await _controller
                                                      .deleteCustomer(
                                                        customer.id,
                                                      );

                                                  setState(() {
                                                    _customers.removeWhere(
                                                      (c) =>
                                                          c.id == customer.id,
                                                    );
                                                  });

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Customer deleted',
                                                      ),
                                                    ),
                                                  );

                                                  Navigator.of(context).pop();
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to delete customer: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },

                                            child: const Text('Delete'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
