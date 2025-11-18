import 'package:bank_saving_system/controllers/deposit_type_controller.dart';
import 'package:bank_saving_system/models/deposit_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DepositTypePage extends StatefulWidget {
  const DepositTypePage({super.key});

  @override
  State<DepositTypePage> createState() => _DepositTypePageState();
}

class _DepositTypePageState extends State<DepositTypePage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController? _nameController;
  TextEditingController? _interestController;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final controller = Provider.of<DepositTypeController>(
        context,
        listen: false,
      );
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !controller.isLoading &&
          controller.hasMore) {
        Future.microtask(
          () => {
            Provider.of<DepositTypeController>(
              context,
              listen: false,
            ).fetchNext(),
          },
        );
      }
    });

    Future.microtask(
      () => {
        Provider.of<DepositTypeController>(
          context,
          listen: false,
        ).fetchDepositTypes(),
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController?.dispose();
    _interestController?.dispose();
    super.dispose();
  }

  Widget buildNewDepositTypeWidget(BuildContext context) {
    _nameController ??= TextEditingController();
    _interestController ??= TextEditingController();
    final DepositTypeController controller = Provider.of<DepositTypeController>(
      context,
    );

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
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),

                    TextFormField(
                      controller: _interestController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Interest Rate % p.a.',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                controller.createDepositType({
                  'name': _nameController?.text ?? '',
                  'annualInterestRate': _interestController?.text ?? '',
                });

                Navigator.pop(context);

                var respMsg =
                    controller.error ??
                    'Deposit Type ${_nameController?.text ?? ''} created';
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(respMsg)));
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditDepositTypeWidget(BuildContext context, DepositType deposit) {
    DepositTypeController controller = Provider.of<DepositTypeController>(
      context,
    );

    _nameController ??= TextEditingController();
    _interestController ??= TextEditingController();

    _nameController?.text = deposit.name;
    _interestController?.text = deposit.annualInterestRate;

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
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),

                    TextFormField(
                      controller: _interestController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Interest Rate',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateDepositType(deposit.id, {
                        'name': _nameController?.text,
                        'annualInterestRate': _interestController?.text,
                      });

                      Navigator.pop(context);
                      var respMsg =
                          controller.error ??
                          'Update ${_nameController?.text ?? ''} success';
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(respMsg)));
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
                        controller.deleteDepositType(deposit.id);

                        if (context.mounted) {
                          Navigator.pop(context);
                          var respMsg =
                              controller.error ??
                              '${_nameController?.text ?? ''} deleted';
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
    final DepositTypeController controller = Provider.of<DepositTypeController>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Deposito Types'),
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
            builder: buildNewDepositTypeWidget,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetPage();
          controller.fetchDepositTypes();
        },

        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 100.0),
          controller: _scrollController,
          itemCount:
              controller.deposittypes.length + (controller.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.deposittypes.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final depositType = controller.deposittypes[index];

            return Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${depositType.name} ${depositType.annualInterestRate}% p.a.',
                    ),
                  ),

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
                          return buildEditDepositTypeWidget(
                            context,
                            depositType,
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
