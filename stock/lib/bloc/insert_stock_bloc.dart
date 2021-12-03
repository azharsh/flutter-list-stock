

import 'package:rxdart/rxdart.dart';
import 'package:stock/model/stock_response.dart';
import 'base.dart';


class InsertStockBLoc extends BaseBloc<String> {

  Observable<String> get response => fetcher.stream;

  insertStock(StockResponse request) async {
    var result = await repository.insertWatch(request);
    fetcher.sink.add(result);
  }


}