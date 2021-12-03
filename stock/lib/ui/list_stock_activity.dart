import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/bloc/insert_stock_bloc.dart';
import 'package:stock/bloc/remove_stock_bloc.dart';
import 'package:stock/bloc/stock_bloc.dart';
import 'package:stock/bloc/stock_event.dart';
import 'package:stock/bloc/stock_state.dart';
import 'package:stock/bloc/watch_bloc.dart';
import 'package:stock/di/injection_container.dart';

import 'package:stock/model/stock_response.dart';
import 'package:stock/repository/repository.dart';


class ListStockActivity extends StatefulWidget {
  const ListStockActivity({Key? key}) : super(key: key);

  @override
  _ListStockActivityState createState() => _ListStockActivityState();
}

class _ListStockActivityState extends State<ListStockActivity> {
  final filterController = TextEditingController();
  late StockBloc _stockBloc;
  late final WatchBloc watchBloc;

  final insertStockBLoc = InsertStockBLoc();
  final removeStockBloc = RemoveStockBloc();

  var listWatch = <StockResponse?>[];

  var listStock = <StockResponse?>[];
  var searchResult = <StockResponse?>[];

  @override
  void initState() {
    super.initState();
    _stockBloc =  StockBloc(repository: sl<Repository>());
    _stockBloc.add(GetStock());

    watchBloc =  WatchBloc(repository: sl<Repository>());
    watchBloc.add(GetWatch());

    _watchtream();
  }

  @override
  void dispose() {
    super.dispose();

    filterController.dispose();
  }


  void _watchtream() {
    watchBloc.stream.listen((state) {
      if (state is LoadedWatch) {
        setState(() {
          listWatch = state.listWatch!.data;
        });
      }
    });
  }


  bool isWatchStock(String symbol) {
    var isWatch = false;
    for (var element in listWatch) {
      if (element!.displaySymbol == symbol) {
        isWatch = true;
      }
    }
    return isWatch;
  }

  int getWatchId(String symbol) {
    var id = 0;
    for (var element in listWatch) {
      if (element!.displaySymbol.toUpperCase() == symbol.toUpperCase()) {
        id = element.id;
      }
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        height: double.infinity,
        child: Column(
          children: [
            TextField(
                controller: filterController,
                decoration: const InputDecoration(
                  hintText: 'Filter...',
                ),
                onChanged: onSearchTextChanged),
            Expanded(
                child: BlocProvider(
                    create: (_) => _stockBloc,
                    child: BlocBuilder<StockBloc, StockState>(
                      builder: (_, state) {
                        if (state is Loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is Loaded) {
                          listStock.clear();
                          listStock.addAll(state.listStock);
                          return ListView.builder(
                              itemCount: searchResult.isNotEmpty ||
                                      filterController.text.isNotEmpty
                                  ? searchResult.length
                                  : listStock.length,
                              itemBuilder: (BuildContext context, int index) {
                                var itemData = searchResult.isNotEmpty ||
                                        filterController.text.isNotEmpty
                                    ? searchResult[index]
                                    : listStock[index];
                                var isWatch = isWatchStock(itemData!.displaySymbol);
                                return  Container(
                                    key: widget.key,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(itemData.displaySymbol,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(itemData.description,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(itemData.type)
                                          ],
                                        ),
                                        GestureDetector(
                                            key: widget.key,
                                            onTap: () {
                                              setState(() {
                                                if (isWatch) {
                                                  var id = getWatchId(itemData.displaySymbol);
                                                  // isWatch = false;
                                                  removeStockBloc.removeWatch(id);
                                                } else {
                                                  // isWatch = true;
                                                  insertStockBLoc.insertStock(itemData);
                                                }
                                                _watchtream();
                                                watchBloc.add(GetWatch());
                                                _stockBloc.add(GetStock());
                                              });
                                            },
                                            child: isWatch
                                                ? Icon(Icons.remove_red_eye, key: widget.key,)
                                                : Icon(Icons.remove_red_eye_outlined, key: widget.key,))
                                      ],
                                    ));
                              });
                        } else {
                          return Container();
                        }
                      },
                    ))),
          ],
        ));
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var element in listStock) {
      if (element!.displaySymbol.toUpperCase().contains(text.toUpperCase())) {
        searchResult.add(element);
      }
    }

    setState(() {});
  }
}
