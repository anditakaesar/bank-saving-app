import 'package:bank_saving_system/controllers/customer_controller.dart';
import 'package:bank_saving_system/models/customer_model.dart';
import 'package:bank_saving_system/views/account_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerController>(context, listen: false).fetchCustomers();
    });
  }

  void _scrollListener() {
    final controller = Provider.of<CustomerController>(context, listen: false);
    final reachingEnd =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent;

    if (reachingEnd && !controller.isLoading && controller.hasMore) {
      Provider.of<CustomerController>(
        context,
        listen: false,
      ).fetchNextCustomers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildNewCustomerWidget(BuildContext context) {
    final nameController = TextEditingController();
    final controller = Provider.of<CustomerController>(context);

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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                controller.createCustomer({'name': nameController.text});

                Navigator.pop(context);

                var msg =
                    controller.error ??
                    'Customer ${nameController.text} created successfully';

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(msg)));
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditCustomerWidget(BuildContext context, Customer customer) {
    final nameController = TextEditingController(text: customer.name);
    final customerController = Provider.of<CustomerController>(context);

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
                  'Edit Customer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await customerController.updateCustomer(customer.id, {
                        'name': nameController.text,
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                        var respMsg =
                            customerController.error ??
                            'Edit ${nameController.text} success';
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(respMsg)));
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
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this item?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false), // cancel
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () =>
                                    Navigator.pop(context, true), // confirm
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await customerController.deleteCustomer(customer.id);

                        if (context.mounted) {
                          Navigator.pop(context);
                          var respMsg =
                              customerController.error ??
                              '${nameController.text} deleted';
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(respMsg)));
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
  }

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Provider.of<CustomerController>(
      context,
    );

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
            builder: buildNewCustomerWidget,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refresh();
        },

        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 100.0),
          controller: _scrollController,
          itemCount:
              controller.customers.length + (controller.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.customers.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final customer = controller.customers[index];
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
                            return buildEditCustomerWidget(context, customer);
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
}
