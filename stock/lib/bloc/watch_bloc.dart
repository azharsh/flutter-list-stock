


import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/bloc/stock_event.dart';
import 'package:stock/bloc/stock_state.dart';
import 'package:stock/model/watch_response.dart';
import 'package:stock/repository/repository.dart';


class WatchBloc extends Bloc<StockEvent, StockState> {
  final Repository repository;

  WatchBloc({required this.repository}) : super(Empty());

  @override
  Stream<StockState> mapEventToState(
      StockEvent event,
      ) async* {
    yield Loading();
    final failureOrGetMe = await repository.getWatch();
    yield* _eitherLoadedOrErrorState(failureOrGetMe);
  }

  Stream<StockState> _eitherLoadedOrErrorState(
      Either<String, WatchResponse?> failureOrGetMe) async* {
    yield failureOrGetMe.fold(
          (failure) => Error(message: failure),
          (listWatch) => LoadedWatch(listWatch: listWatch),
    );
  }
}
