import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper/counter_bloc.dart';

void main() {
  testWidgets('test child', (tester) async {
    // shouldn't create bloc outside of creator callback for real app
    final bloc = CounterBloc();
    final app = MaterialApp(
      home: BlocProvider<CounterBloc>(
        creator: (context, _bag) => bloc,
        child: Builder(
          builder: (context) {
            final bloc = BlocProvider.of<CounterBloc>(context);
            return StreamBuilder<int>(
              initialData: bloc.count.value,
              stream: bloc.count,
              builder: (context, snap) => Text('${snap.data}'),
            );
          },
        ),
      ),
    );

    await _performCounterTest(tester, app, bloc);
  });

  testWidgets('test builder', (tester) async {
    // shouldn't create bloc outside of creator callback for real app
    final bloc = CounterBloc();
    final app = MaterialApp(
      home: BlocProvider<CounterBloc>.builder(
        creator: (context, _bag) => bloc,
        builder: (context, bloc) => StreamBuilder<int>(
              initialData: bloc.count.value,
              stream: bloc.count,
              builder: (context, snap) => Text('${snap.data}'),
            ),
      ),
    );

    await _performCounterTest(tester, app, bloc);
  });

  testWidgets('test disposing', (tester) async {
    final key = GlobalKey<_StatefulTestWidgetState>();
    final app = StatefulTestWidget(key: key);

    await tester.pumpWidget(app);

    expect(find.text('0'), findsOneWidget);
    expect(key.currentState.bloc.disposed, false);
    expect(key.currentState.registeredOnDisposedCalled, false);

    key.currentState.removeCounter();
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNothing);
    expect(key.currentState.bloc.disposed, true);
    expect(key.currentState.registeredOnDisposedCalled, true);
  });
}

Future<void> _performCounterTest(
    WidgetTester tester, Widget app, CounterBloc bloc) async {
  await tester.pumpWidget(app);

  expect(find.text('0'), findsOneWidget);
  expect(find.text('1'), findsNothing);

  bloc.increment.add(null);
  await tester.pumpAndSettle();

  expect(find.text('0'), findsNothing);
  expect(find.text('1'), findsOneWidget);

  bloc.increment.add(null);
  bloc.increment.add(null);
  await tester.pumpAndSettle();

  expect(find.text('3'), findsOneWidget);
}

class StatefulTestWidget extends StatefulWidget {
  const StatefulTestWidget({Key key}) : super(key: key);
  @override
  _StatefulTestWidgetState createState() => _StatefulTestWidgetState();
}

class _StatefulTestWidgetState extends State<StatefulTestWidget> {
  // shouldn't create bloc outside of creator callback for real app
  final bloc = CounterBloc();
  var registeredOnDisposedCalled = false;
  var _userCounter = true;
  @override
  Widget build(BuildContext context) {
    if (_userCounter) {
      return MaterialApp(
        home: BlocProvider<CounterBloc>.builder(
          creator: (context, _bag) {
            _bag.register(onDisposed: () => registeredOnDisposedCalled = true);
            return bloc;
          },
          builder: (context, bloc) => StreamBuilder<int>(
                initialData: bloc.count.value,
                stream: bloc.count,
                builder: (context, snap) => Text('${snap.data}'),
              ),
        ),
      );
    } else {
      return Container();
    }
  }

  void removeCounter() {
    setState(() {
      _userCounter = false;
    });
  }
}
