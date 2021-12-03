import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/model/watch_response.dart';
import 'endpoint.dart';
import 'env.dart';
import "package:http/http.dart" as http;
import 'package:dio/dio.dart';

class ApiProvider {
  final Dio dio;

  ApiProvider({required this.dio});

  //get stock
  Future<List<StockResponse?>> getStock() async {
    try {
      final response = await http.get(Uri.parse(BASE_URL + STOCK));
      List<StockResponse> listResponse =
          stockResponseFromJson(response.body.toString());
      return listResponse;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //insert stock
  Future<String?> insertStock(StockResponse request) async {
    final response = await dio.post(BASE_LOCAL_URL, data: request);
    try {
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (e) {
      return "Failed";
    }
  }

  //delete stock
  Future<String?> removeStock(int id) async {
    final response = await dio.delete(BASE_LOCAL_URL + "/" + id.toString());
    try {
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (e) {
      return "Failed";
    }
  }

  // get watch
  Future<WatchResponse?> getWatch() async {
    final response = await dio.get(BASE_LOCAL_URL);
    try {
      if (response.statusCode == 200) {
        print(response);
        return WatchResponse.fromJson(json.decode(response.toString()));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
