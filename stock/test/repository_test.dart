import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/network/api_provider.dart';
import 'package:stock/repository/repository.dart';


void main() {
  late RepositoryImpl repository;
  late ApiProvider apiProvider;
  Dio dio;

  setUp(() {
    dio = Dio();
    apiProvider = ApiProvider(dio: dio);
    repository = RepositoryImpl(apiProvider: apiProvider);
  });

  group('getStock', () {
    final stockModel = StockResponse(
      id: 1,
      currency: "Btc",
      description: "bitcoin",
      displaySymbol: "BTC",
      figi: "btc",
      mic: "btc",
      symbol: "Btc",
      type: "coin",
    );

    group('get Stock', () {
      test(
        'should return api provider when call is successful',
        () async {
          // arrange
          when(apiProvider.getStock()).thenAnswer((_) async => [stockModel]);

          // act
          final result = await repository.getStock();

          // assert
          verify(repository.getStock());
          expect(result, equals(Right([stockModel])));
        },
      );

      test(
        'should return failure remote data source when call remote data source is unsuccessful',
        () async {
          // arrange
          when(apiProvider.getStock()).thenThrow(String);

          // act
          final result = await repository.getStock();

          // assert
          verify(apiProvider.getStock());
          expect(result, equals(const Left(String)));
        },
      );
    });
  });
}
