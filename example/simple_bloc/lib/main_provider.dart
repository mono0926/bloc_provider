import 'package:flutter/material.dart';
import 'package:simple_bloc/bloc/counter_bloc.dart';
import 'package:simple_bloc/bloc/counter_bloc_provider.dart';

void main() => runApp(
      CounterBlocProvider(
        bloc: CounterBloc(),
        child: App(),
      ),
    );

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CounterBlocProvider.of(context);
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
