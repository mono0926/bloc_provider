import 'package:flutter/material.dart';

import 'bloc/counter_bloc.dart';

void main() => runApp(App(bloc: CounterBloc()));

class App extends StatelessWidget {
  final CounterBloc bloc;

  const App({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<int>(
            stream: bloc.count,
            initialData: bloc.count.valueWrapper?.value,
            builder: (context, snap) => Text(
              'count: ${snap.data}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => bloc.increment.add(null),
        ),
      ),
    );
  }
}
