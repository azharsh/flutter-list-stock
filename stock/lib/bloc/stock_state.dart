


import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/model/watch_response.dart';

@immutable
abstract class StockState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends StockState {}

class Loading extends StockState {}

class Loaded extends StockState {
  final List<StockResponse?> listStock;

  Loaded({required this.listStock});
}


class LoadedWatch extends StockState {
  final WatchResponse? listWatch;

  LoadedWatch({required this.listWatch});
}

class Error extends StockState {
  final String message;

  Error({required this.message});
}