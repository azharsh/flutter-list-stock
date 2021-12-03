// To parse this JSON data, do
//
//     final stockResponse = stockResponseFromJson(jsonString);

import 'dart:convert';

List<StockResponse> stockResponseFromJson(String str) => List<StockResponse>.from(json.decode(str).map((x) => StockResponse.fromJson(x)));

String stockResponseToJson(List<StockResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockResponse {
  StockResponse({
    required this.id,
    required this.currency,
    required this.description,
    required this.displaySymbol,
    required this.figi,
    required this.mic,
    required this.symbol,
    required this.type,
  });

  int id;
  String currency;
  String description;
  String displaySymbol;
  String figi;
  String mic;
  String symbol;
  String type;

  factory StockResponse.fromJson(Map<String, dynamic> json) => StockResponse(
    id : json["id"],
    currency: json["currency"],
    description: json["description"],
    displaySymbol: json["displaySymbol"],
    figi: json["figi"],
    mic: json["mic"],
    symbol: json["symbol"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "currency": currency,
    "description": description,
    "displaySymbol": displaySymbol,
    "figi": figi,
    "mic": mic,
    "symbol": symbol,
    "type": type,
  };
}


