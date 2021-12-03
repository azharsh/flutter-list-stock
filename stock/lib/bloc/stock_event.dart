import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class StockEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetStock extends StockEvent {}

class GetWatch extends StockEvent {}