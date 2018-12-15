import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'bloc/counter_bloc.dart';

void main() => runApp(
      BlocProvider<CounterBloc>(
        creator: (context, _bag) => CounterBloc(),
        child: App(),
      ),
    );

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<int>(
            stream: bloc.count,
            initialData: bloc.count.value,
            builder: (context, snap) => Text(
                  'count: ${snap.data}',
                  style: Theme.of(context).textTheme.title,
                ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => bloc.increment.add(null),
        ),
      ),
    );
  }
}
