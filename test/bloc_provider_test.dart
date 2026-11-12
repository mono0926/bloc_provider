import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helper/counter_bloc.dart';

void main() {
  testWidgets('test child', (tester) async {
    // shouldn't create bloc outside of creator callback for real app
    final bloc = CounterBloc();
    final app = MaterialApp(
      home: BlocProvider<CounterBloc>(
        creator: (context, bag) => bloc,
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
        creator: (context, bag) => bloc,
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
    final app = _StatefulTestWidget(key: key);

    await tester.pumpWidget(app);

    expect(find.text('0'), findsOneWidget);
    expect(key.currentState!.bloc.disposed, false);
    expect(key.currentState!.registeredOnDisposedCalled, false);

    key.currentState!.removeCounter();
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNothing);
    expect(key.currentState!.bloc.disposed, true);
    expect(key.currentState!.registeredOnDisposedCalled, true);
  });
}

Future<void> _performCounterTest(
  WidgetTester tester,
  Widget app,
  CounterBloc bloc,
) async {
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

class const _StatefulTestWidget({super.key}) extends StatefulWidget {
  @override
  _StatefulTestWidgetState createState() => _StatefulTestWidgetState();
}

class _StatefulTestWidgetState() extends State<_StatefulTestWidget> {
  // shouldn't create bloc outside of creator callback for real app
  final CounterBloc bloc = CounterBloc();
  bool registeredOnDisposedCalled = false;
  bool _userCounter = true;
  @override
  Widget build(BuildContext context) {
    if (_userCounter) {
      return MaterialApp(
        home: BlocProvider<CounterBloc>.builder(
          creator: (context, bag) {
            bag.register(onDisposed: () => registeredOnDisposedCalled = true);
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
