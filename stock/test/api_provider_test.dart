import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stock/model/stock_response.dart';
import "package:http/http.dart" as http;
import 'package:stock/network/api_provider.dart';
import 'fixture/fixture_reader.dart';

class MockNetworkServices extends Mock {}

void main() {
  Dio dio;
  late ApiProvider apiProvider;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    dio = Dio();
    apiProvider = ApiProvider(dio: dio);
  });

  group('getStock', () {
    final stockModel =
        StockResponse.fromJson(json.decode(fixture('stock.json')));

    test(
      'should return Me when the response is 200(success)',
      () async {
        // arrange
        when(http.get((Uri.parse('endpoint'))))
            .thenAnswer((_) async => http.Response(fixture('stock.json'), 200));
        // act
        final result = await apiProvider.getStock();

        // assert
        expect(result, equals(stockModel));
      },
    );

    test(
      'should throw a ServerExceptions when the response code is 404 or unsuccessful',
      () async {
        // arrange
        when(http.get((Uri.parse('endpoint')))).thenAnswer(
            (_) async => http.Response("Something whent wrong", 404));

        // act
        final call = apiProvider.getStock();

        // assert
        expect(() => call, throwsA(null));
      },
    );
  });
}
