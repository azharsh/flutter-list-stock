


import 'package:rxdart/rxdart.dart';
import 'package:stock/di/injection_container.dart';
import 'package:stock/network/api_provider.dart';
import 'package:stock/repository/repository.dart';


abstract class BaseBloc<T> {
  final repository = RepositoryImpl(apiProvider: sl<ApiProvider>());
  final fetcher = PublishSubject<T>();

  dispose() {
    fetcher.close();
  }
}
