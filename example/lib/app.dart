import 'package:bloc_provider_example/bloc/counter_bloc_provider.dart';
import 'package:bloc_provider_example/const.dart';
import 'package:bloc_provider_example/page/counter_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CounterBlocProvider(
      child: MaterialApp(
        title: Const.title,
        home: CounterPage(),
      ),
    );
  }
}
