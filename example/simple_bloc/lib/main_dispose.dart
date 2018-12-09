import 'package:flutter/material.dart';
import 'package:simple_bloc/bloc/counter_bloc.dart';
import 'package:simple_bloc/bloc/counter_bloc_provider.dart';

void main() => runApp(MyStatefulWidget());

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  CounterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CounterBloc();
  }

  @override
  Widget build(BuildContext context) {
    return CounterBlocProvider(
      bloc: _bloc,
      child: App(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CounterBlocProvider.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<int>(
            stream: bloc.count,
            initialData: 0,
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
