



import 'package:dartz/dartz.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/model/watch_response.dart';
import 'package:stock/network/api_provider.dart';

abstract class Repository {

  Future<Either<String,List<StockResponse?>>> getStock();

  Future<Either<String,WatchResponse?>> getWatch();

  Future<String?> insertWatch(StockResponse request);

  Future<String?> removeStock(int id);
}

class RepositoryImpl implements Repository{

  final ApiProvider apiProvider;

  RepositoryImpl({required this.apiProvider});


  @override
  Future<Either<String, List<StockResponse?>>> getStock() async {
    try {
      final response = await apiProvider.getStock();
      return Right(response);
    } catch (ex) {
      return Left(ex.toString());
    }

  }

  @override
  Future<Either<String,WatchResponse?>> getWatch() async {
    try {
      final response = await apiProvider.getWatch();
      return Right(response);
    } catch (ex) {
      return Left(ex.toString());
    }

  }

  @override
  Future<String?> insertWatch(StockResponse request) async {
    try {
      final response = await apiProvider.insertStock(request);
      return response;
    } catch (ex) {
      return ex.toString();
    }

  }

  @override
  Future<String?> removeStock(int id) async {
    try {
      final response = await apiProvider.removeStock(id);
      return response;
    } catch (ex) {
      return ex.toString();
    }
  }

}