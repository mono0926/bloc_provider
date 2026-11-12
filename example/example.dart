import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:material_ui/material_ui.dart';

class CounterBloc() implements Bloc {
  this {
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
    creator: (context, bag) => CounterBloc(),
    child: const MaterialApp(home: CounterPage()),
  ),
);

class const CounterPage({super.key}) extends StatelessWidget {
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
