import 'dart:convert';
import 'dart:io';

import 'package:bank_saving_system/models/customer_model.dart';
import 'package:bank_saving_system/utils/api.dart';
import 'package:flutter/foundation.dart';

class CustomerController extends ChangeNotifier {
  final _customersEndpoint = '/customers';
  final _apiUtil = ApiUtil();

  List<Customer> _customers = [];
  bool _isLoading = false;
  bool _hasMore = false;
  String? _error;
  int _page = 1;
  final int _size = 10;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> refresh() async {
    _page = 1;
    await fetchCustomers();
  }

  Future<void> fetchCustomers({bool append = false}) async {
    _isLoading = true;
    _error = null;
    final int pageToFetch = append ? _page + 1 : 1;
    notifyListeners();

    try {
      final response = await _apiUtil.getRequest(
        _customersEndpoint,
        queryParams: {'page': pageToFetch.toString(), 'size': _size.toString()},
      );

      if (response.statusCode == HttpStatus.ok) {
        var fetchedCustomer = CustomerList.fromJson(
          json.decode(response.body),
        ).customers;
        _hasMore = fetchedCustomer.length == _size;

        if (append) {
          _page = pageToFetch;
          _customers.addAll(fetchedCustomer);
        } else {
          _page = 1;
          _customers = fetchedCustomer;
        }
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNextCustomers() async {
    await fetchCustomers(append: true);
  }

  Future<void> createCustomer(Map<String, dynamic> data) async {
    _error = null;
    final response = await _apiUtil.postRequest(_customersEndpoint, body: data);

    try {
      if (response.statusCode == HttpStatus.created) {
        var createdCustomer = Customer.fromJson(
          json.decode(response.body)['body'],
        );
        _customers.add(createdCustomer);
      } else {
        throw Exception('Failed to create customer');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }

  Future<void> updateCustomer(int id, Map<String, dynamic> data) async {
    _error = null;
    final response = await _apiUtil.patchRequest(
      '$_customersEndpoint/$id',
      body: data,
    );
    final idx = _customers.indexWhere((c) => c.id == id);

    try {
      if (response.statusCode == HttpStatus.ok) {
        var updatedCust = Customer.fromJson(json.decode(response.body)['body']);
        _customers[idx] = updatedCust;
      } else {
        throw Exception('Failed to update customer');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }

  Future<void> deleteCustomer(int id) async {
    _error = null;
    final response = await _apiUtil.deleteRequest('$_customersEndpoint/$id');
    final idx = _customers.indexWhere((c) => c.id == id);

    try {
      if (response.statusCode == HttpStatus.ok) {
        Customer.fromJson(json.decode(response.body)['body']);
        _customers.removeAt(idx);
      } else {
        throw Exception('Failed to delete customer');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }
}
