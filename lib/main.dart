import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:project_pixel_6/store/state.dart';
import 'package:redux/redux.dart';
import 'models/app_state.dart';
import 'widgets/customer_list.dart';

void main() {
  final store = createStore();
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRUD App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CustomerList(),
      ),
    );
  }
}
