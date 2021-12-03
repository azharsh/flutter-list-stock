import 'dart:convert';

import 'package:stock/model/stock_response.dart';

WatchResponse watchResponseFromJson(String str) => WatchResponse.fromJson(json.decode(str));

String watchResponseToJson(WatchResponse data) => json.encode(data.toJson());

class WatchResponse {
  WatchResponse({
    required this.data,
  });

  List<StockResponse> data;

  factory WatchResponse.fromJson(Map<String, dynamic> json) => WatchResponse(
    data: List<StockResponse>.from(json["data"].map((x) => StockResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


