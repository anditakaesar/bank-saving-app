import 'dart:convert';
import 'dart:io';

import 'package:bank_saving_system/models/api_response_model.dart';
import 'package:bank_saving_system/models/deposit_type_model.dart';
import 'package:bank_saving_system/utils/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DepositTypeController extends ChangeNotifier {
  final _depositTypeEndpoint = '/deposit-types';
  final _errorFetch = 'Failed to load deposit types';
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

  Future<void> refresh() async {
    _page = 1;
    await fetchDepositTypes();
  }

  Future<void> fetchDepositTypes({bool append = false}) async {
    _isLoading = true;
    _error = null;
    final int pageToFetch = append ? _page + 1 : 1;
    notifyListeners();

    try {
      final response = await _apiUtil.getRequest(
        _depositTypeEndpoint,
        queryParams: {'page': pageToFetch.toString(), 'size': _size.toString()},
      );

      if (response.statusCode == HttpStatus.ok) {
        var fetchedDepositTypes = DepositTypeList.fromJson(
          json.decode(response.body),
        ).deposittypes;
        _hasMore = fetchedDepositTypes.length == _size;

        if (append) {
          _page = pageToFetch;
          _depositTypes.addAll(fetchedDepositTypes);
        } else {
          _page = 1;
          _depositTypes = fetchedDepositTypes;
        }
      } else {
        throw Exception(_errorFetch);
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> fetchNext() async {
    await fetchDepositTypes(append: true);
  }

  Future<void> createDepositType(Map<String, dynamic> data) async {
    _error = null;
    final errorCreateMsg = 'Failed to create deposit type';
    final response = await _apiUtil.postRequest(
      _depositTypeEndpoint,
      body: data,
    );

    try {
      if (response.statusCode == HttpStatus.created) {
        var createdCustomer = DepositType.fromJson(
          json.decode(response.body)['body'],
        );
        _depositTypes.add(createdCustomer);
      } else if (response.statusCode == HttpStatus.conflict) {
        var message = CommonResponse.fromJson(
          json.decode(response.body),
        ).message;
        _error = message ?? errorCreateMsg;
      } else {
        throw Exception(errorCreateMsg);
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }

  Future<void> updateDepositType(int id, Map<String, dynamic> data) async {
    _error = null;
    final errorUpdateMsg = 'Failed to update deposit type';
    final response = await _apiUtil.patchRequest(
      '$_depositTypeEndpoint/$id',
      body: data,
    );
    final idx = _depositTypes.indexWhere((c) => c.id == id);

    try {
      if (response.statusCode == HttpStatus.ok) {
        var updatedDepositType = DepositType.fromJson(
          json.decode(response.body)['body'],
        );
        _depositTypes[idx] = updatedDepositType;
      } else if (response.statusCode == HttpStatus.conflict) {
        var message = CommonResponse.fromJson(
          json.decode(response.body),
        ).message;
        _error = message ?? errorUpdateMsg;
      } else {
        throw Exception(errorUpdateMsg);
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    notifyListeners();
  }

  Future<void> deleteDepositType(int id) async {
    _error = null;
    final response = await _apiUtil.deleteRequest('$_depositTypeEndpoint/$id');
    final idx = _depositTypes.indexWhere((c) => c.id == id);

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
