import 'dart:convert';
import 'dart:io';
import 'package:bank_saving_system/controllers/base_controller.dart';
import 'package:bank_saving_system/models/customer_model.dart';

class CustomerController extends BaseController {
  Future<CustomerModel> fetchCustomers({int page = 1, int size = 10}) async {
    final response = await getRequest(
      '/customers',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );

    if (response.statusCode == HttpStatus.ok) {
      return CustomerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer(Map<String, dynamic> data) async {
    final response = await postRequest('/customers', body: data);

    if (response.statusCode == HttpStatus.created) {
      return Customer.fromJson(json.decode(response.body)['body']);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Customer> updateCustomer(int id, Map<String, dynamic> data) async {
    final response = await patchRequest('/customers/$id', body: data);

    if (response.statusCode == HttpStatus.ok) {
      return Customer.fromJson(json.decode(response.body)['body']);
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<Customer> deleteCustomer(int id) async {
    final response = await deleteRequest('/customers/$id');

    if (response.statusCode == HttpStatus.ok) {
      return Customer.fromJson(json.decode(response.body)['body']);
    } else {
      throw Exception('Failed to delete customer');
    }
  }
}
