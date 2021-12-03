import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stock/bloc/stock_bloc.dart';
import 'package:stock/network/api_provider.dart';
import 'package:stock/repository/repository.dart';


final sl = GetIt.instance;

Future<void> init() async {

  final dio = Dio();
  final httpClient = HttpClient();
  sl.registerLazySingleton(() => httpClient);
  sl.registerLazySingleton(() => ApiProvider(dio: dio));

  sl.registerLazySingleton<Repository>(
          () => RepositoryImpl(apiProvider:sl()));

  sl.registerFactory(() => StockBloc(repository: sl.call()));

}