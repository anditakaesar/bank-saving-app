class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CustomerModel {
  final List<Customer> customers;

  CustomerModel({required this.customers});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    var list = json['body']['list'] as List;
    List<Customer> customers = list.map((i) => Customer.fromJson(i)).toList();
    return CustomerModel(customers: customers);
  }
}