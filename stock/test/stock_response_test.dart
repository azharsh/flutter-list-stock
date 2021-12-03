

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock/model/stock_response.dart';

import 'fixture/fixture_reader.dart';

void main() {

  final stockModel =  StockResponse(
    id:1,
    currency:"Btc",
    description:"bitcoin",
    displaySymbol:"BTC",
    figi:"btc",
    mic:"btc",
    symbol:"Btc",
    type:"coin",
  );

  test(
    'should be a subclass of Account Entity',
        () async {
      // assert
      expect(stockModel, isA<StockResponse>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid JSON',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('stock.json'));
        // act
        final result = StockResponse.fromJson(jsonMap);
        // assert
        expect(result, stockModel);
      },
    );
  });


}

