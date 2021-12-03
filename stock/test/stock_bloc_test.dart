import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stock/bloc/stock_bloc.dart';
import 'package:stock/bloc/stock_event.dart';
import 'package:stock/bloc/stock_state.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/network/api_provider.dart';
import 'package:stock/repository/repository.dart';

void main() {
  late StockBloc bloc;
  late Repository repository;
  ApiProvider apiProvider;
  Dio dio;

  setUp(() {
    dio = Dio();
    apiProvider = ApiProvider(dio: dio);
    repository = RepositoryImpl(apiProvider: apiProvider);
    bloc = StockBloc(repository: repository);
  });

  test(
    'initialState should be empty',
    () async {
      // assert
      expect(bloc.state, equals(Empty()));
    },
  );

  group('GetMe', () {
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

    test(
      'should get data from repository',
      () async {
        // arrange
        when(repository.getStock())
            .thenAnswer((_) async => Right([stockModel]));

        // act
        bloc.add(GetStock());
        await untilCalled(repository.getStock());

        // assert
        verify(repository.getStock());
      },
    );

    test(
      'should emit Loading, Loaded when data is get Successfully',
      () {
        // arrange
        when(repository.getStock())
            .thenAnswer((_) async => Right([stockModel]));

        // assert later
        final expected = [
          Loading(),
          Loaded(listStock: [stockModel])
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetStock());
      },
    );

    test(
      'should emit Loading, Error when get data is fail',
      () {
        // arrange
        when(repository.getStock()).thenAnswer((_) async => Left(""));

        // assert later
        final expected = [Loading(), Error(message: "Something whent wrong")];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetStock());
      },
    );
  });
}
