import 'dart:convert';
import 'dart:io';

import 'package:bank_saving_system/models/deposit_type_model.dart';
import 'package:bank_saving_system/utils/api.dart';
import 'package:flutter/foundation.dart';

class DepositTypeController extends ChangeNotifier {
  final _depositTypeEndpoint = '/deposit-types';
  final _apiUtil = ApiUtil();

  List<DepositType> _depositTypes = [];
  bool _isLoading = false;
  bool _hasMore = false;
  String? _error;
  int _page = 1;
  final int _size = 10;

  List<DepositType> get deposittypes => _depositTypes;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  void resetPage() {
    _page = 1;
  }

  Future<void> fetchDepositTypes({bool append = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (append) {
      _page++;
    }

    try {
      final response = await _apiUtil.getRequest(
        _depositTypeEndpoint,
        queryParams: {'page': _page.toString(), 'size': _size.toString()},
      );

      if (response.statusCode == HttpStatus.ok) {
        var fetchedDepositTypes = DepositTypeList.fromJson(
          json.decode(response.body),
        ).deposittypes;

        if (append) {
          _depositTypes.addAll(fetchedDepositTypes);
        } else {
          _depositTypes = fetchedDepositTypes;
        }
      } else {
        throw Exception('Failed to load deposit types');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    _hasMore = _depositTypes.length == _size;
    _isLoading = false;

    notifyListeners();
  }

  Future<void> fetchNext() async {
    await fetchDepositTypes(append: true);
  }

  Future<void> createDepositType(Map<String, dynamic> data) async {
    final response = await _apiUtil.postRequest(
      _depositTypeEndpoint,
      body: data,
    );
    _error = null;

    try {
      if (response.statusCode == HttpStatus.created) {
        var createdCustomer = DepositType.fromJson(
          json.decode(response.body)['body'],
        );
        _depositTypes.add(createdCustomer);
      } else {
        throw Exception('Failed to create deposit type');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }

  Future<void> updateDepositType(int id, Map<String, dynamic> data) async {
    final response = await _apiUtil.patchRequest(
      '$_depositTypeEndpoint/$id',
      body: data,
    );
    final idx = _depositTypes.indexWhere((c) => c.id == id);
    _error = null;

    try {
      if (response.statusCode == HttpStatus.ok) {
        var updatedDepositType = DepositType.fromJson(
          json.decode(response.body)['body'],
        );
        _depositTypes[idx] = updatedDepositType;
      } else {
        throw Exception('Failed to update deposit type');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }

  Future<void> deleteDepositType(int id) async {
    final response = await _apiUtil.deleteRequest('$_depositTypeEndpoint/$id');
    final idx = _depositTypes.indexWhere((c) => c.id == id);
    _error = null;

    try {
      if (response.statusCode == HttpStatus.ok) {
        DepositType.fromJson(json.decode(response.body)['body']);
        _depositTypes.removeAt(idx);
      } else {
        throw Exception('Failed to delete deposit type');
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }
}
