import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class CounterBloc implements Bloc {
  CounterBloc() {
    _countController.add(0);
  }

  final _countController = StreamController<int>();
  int _count = 0;

  Stream<int> get count => _countController.stream;

  void increment() {
    _count++;
    _countController.add(_count);
  }

  @override
  void dispose() {
    _countController.close();
  }
}

void main() => runApp(
      BlocProvider<CounterBloc>(
        creator: (_context, _bag) => CounterBloc(),
        child: const MaterialApp(home: CounterPage()),
      ),
    );

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Example')),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.count,
          initialData: 0,
          builder: (context, snap) => Text(
            'count: ${snap.data}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bloc.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
