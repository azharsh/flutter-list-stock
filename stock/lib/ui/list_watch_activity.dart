import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/bloc/remove_stock_bloc.dart';
import 'package:stock/bloc/stock_event.dart';
import 'package:stock/bloc/stock_state.dart';
import 'package:stock/bloc/watch_bloc.dart';
import 'package:stock/di/injection_container.dart';
import 'package:stock/model/stock_response.dart';
import 'package:stock/repository/repository.dart';

class ListWatchActivity extends StatefulWidget {
  const ListWatchActivity({Key? key}) : super(key: key);

  @override
  _ListWatchActivityState createState() => _ListWatchActivityState();
}

class _ListWatchActivityState extends State<ListWatchActivity> {
  late final WatchBloc watchBloc;
  final removeStockBloc = RemoveStockBloc();

  var listStock = <StockResponse?>[];

  @override
  void initState() {
    super.initState();
    watchBloc = WatchBloc(repository: sl<Repository>());
    watchBloc.add(GetWatch());
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
            create: (_) => watchBloc,
            child: BlocBuilder<WatchBloc, StockState>(builder: (_, state) {
              if (state is Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadedWatch) {
                listStock.clear();
                listStock.addAll(state.listWatch!.data);
                return ListView.builder(
                    itemCount: listStock.length,
                    itemBuilder: (BuildContext context, int index) {
                      var itemData = listStock[index];
                      return Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      itemData != null
                                          ? itemData.displaySymbol
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      itemData != null
                                          ? itemData.description
                                          : "",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(itemData != null ? itemData.type : "")
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  removeStockBloc.removeWatch(itemData!.id);
                                  setState(() {
                                    watchBloc.add(GetWatch());
                                  });
                                },
                                child: Icon(Icons.remove_red_eye),
                              )
                            ],
                          ));
                    });
              } else {
                return Container();
              }
            })));
  }
}
