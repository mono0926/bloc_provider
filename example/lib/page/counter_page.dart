import 'package:bloc_provider_example/bloc/counter_bloc_provider.dart';
import 'package:bloc_provider_example/const.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CounterBlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Const.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:'),
            StreamBuilder(
              initialData: bloc.count.value,
              stream: bloc.count,
              builder: (context, snap) => Text(
                    '${snap.data}',
                    style: Theme.of(context).textTheme.display1,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.increment.add(null),
        child: Icon(Icons.add),
        tooltip: 'Increment',
      ),
    );
  }
}
