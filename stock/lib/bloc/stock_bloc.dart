import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/bloc/stock_event.dart';
import 'package:stock/bloc/stock_state.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/repository/repository.dart';
import 'package:dartz/dartz.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final Repository repository;

  StockBloc({required this.repository}) : super(Empty());

  @override
  Stream<StockState> mapEventToState(
    StockEvent event,
  ) async* {
    yield Loading();
    final failureOrGetMe = await repository.getStock();
    yield* _eitherLoadedOrErrorState(failureOrGetMe);
  }

  Stream<StockState> _eitherLoadedOrErrorState(
      Either<String, List<StockResponse?>> failureOrGetMe) async* {
    yield failureOrGetMe.fold(
      (failure) => Error(message: failure),
      (listStock) => Loaded(listStock: listStock),
    );
  }
}
