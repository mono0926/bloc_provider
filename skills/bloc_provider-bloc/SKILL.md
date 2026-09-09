---
name: bloc_provider-bloc
description: >-
  Use when providing, accessing, and automatically disposing BLoC (Business Logic Component) instances
  across Flutter widget subtrees using bloc_provider.
---

# bloc_provider BLoC Management Guide

`bloc_provider` manages the lifecycle of BLoC (Business Logic Component) classes, providing $O(1)$ subtree lookups and automatic resource disposal when the enclosing widget tree unmounts.

## Guidelines

- **Implementing the `Bloc` Interface**:
  - Always implement the `Bloc` interface on your business logic classes.
  - Implement `void dispose()` to close all active `StreamController`s, sinks, and subscriptions.
- **Providing BLoCs**:
  - Wrap the target subtree with `BlocProvider<MyBloc>(creator: (context, bag) => MyBloc(), child: ...)`.
  - The BLoC is lazily created upon first access and automatically disposed when the provider's state unmounts.
- **Accessing BLoCs**:
  - Call `BlocProvider.of<MyBloc>(context)` to retrieve the nearest ancestor BLoC.
  - Unlike standard InheritedWidget lookups that cause rebuilding, `BlocProvider.of()` does not trigger widget rebuilds itself; connect outputs to `StreamBuilder` widgets to rebuild only the necessary parts of the UI.

## Examples

### 1. Defining a BLoC

```dart
import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc implements Bloc {
  CounterBloc() {
    _incrementController.listen((_) {
      _countSubject.add(_countSubject.value + 1);
    });
  }

  final _countSubject = BehaviorSubject<int>.seeded(0);
  final _incrementController = StreamController<void>();

  ValueStream<int> get count => _countSubject;
  Sink<void> get increment => _incrementController.sink;

  @override
  void dispose() async {
    await _incrementController.close();
    await _countSubject.close();
  }
}
```

### 2. Providing and Consuming in the Widget Tree

```dart
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      creator: (context, bag) => CounterBloc(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Counter')),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.count,
          initialData: bloc.count.value,
          builder: (context, snapshot) {
            return Text(
              'Count: ${snapshot.data}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.increment.add(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Common Pitfalls & Anti-Patterns

- ❌ **Anti-pattern**: Forgetting to implement `void dispose()` in BLoC classes, causing stream controllers to leak in memory.
  - ✔️ **Correct**: Always close subjects and controllers inside `dispose()`.
- ❌ **Anti-pattern**: Instantiating BLoC directly inside a `StatelessWidget.build()` method without `BlocProvider`.
  - ✔️ **Correct**: Use `BlocProvider(creator: ...)` to tie the BLoC's lifespan to the widget tree lifecycle.
