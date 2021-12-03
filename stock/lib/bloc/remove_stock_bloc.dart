


import 'package:rxdart/rxdart.dart';
import 'package:stock/model/stock_response.dart';
import 'base.dart';


class RemoveStockBloc extends BaseBloc<String> {

  Observable<String> get response => fetcher.stream;

  removeWatch(int id) async {
    var result = await repository.removeStock(id);
    fetcher.sink.add(result);
  }


}