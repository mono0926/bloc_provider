# bloc_provider

Provides bloc to descendant widget (O(1)), and the bloc is disposed appropriately by the state which the bloc_provider holds internally.

## Usage

#### 1. Define some BLoC like this:

```dart
class CounterBloc {
  final _countController = BehaviorSubject<int>(seedValue: 0);
  final _incrementController = PublishSubject<void>();

  CounterBloc() {
    _incrementController
        .scan<int>((sum, _v, _i) => sum + 1, 0)
        .pipe(_countController);
  }

  ValueObservable<int> get count => _countController;
  Sink<void> get increment => _incrementController.sink;

  @override
  void dispose() async {
    await _incrementController.close();
    await _countController.close();
  }
}
```

#### 2. Provide the bloc by using BlocProvider and access the bloc at subtree:

```dart
void main() => runApp(
      // Create and provide the bloc.
      BlocProvider<CounterBloc>(
        creator: (_context, _bag) => CounterBloc(),
        child: App(),
      ),
    );

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the bloc with O(1) computation complexity.
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
          child: const Icon(Icons.add),
          onPressed: () => bloc.increment.add(null),
        ),
      ),
    );
  }
}
```

- Computational complexity of `of` method, which is used for access the bloc is `O(1)`.
    - `of` method can be also called at [State](https://docs.flutter.io/flutter/widgets/State-class.html)'s [initState](https://docs.flutter.io/flutter/widgets/State/initState.html).
- Provided bloc will be disposed when the inner state is disposed 👍


## Examples

- https://github.com/mono0926/bloc_provider/tree/master/example
- [mono0926/wdb106-flutter](https://github.com/mono0926/wdb106-flutter)
- [TaskShare/taskshare-flutter](https://github.com/TaskShare/taskshare-flutter)


## Technical explanation

- [Flutter の BLoC(Business Logic Component)のライフサイクルを正確に管理して提供する Provider パッケージの解説](https://medium.com/flutter-jp/bloc-provider-70e869b11b2f)
  - Japanese only, currently🙇‍🇯🇵

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/mono0926/bloc_provider/issues
