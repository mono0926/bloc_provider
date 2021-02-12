import 'package:flutter/widgets.dart';

import 'counter_bloc.dart';

class CounterBlocProvider extends InheritedWidget {
  const CounterBlocProvider({
    Key? key,
    required Widget child,
    required this.bloc,
  }) : super(key: key, child: child);

  final CounterBloc bloc;

  static CounterBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CounterBlocProvider>()!
        .bloc;
  }

  @override
  bool updateShouldNotify(CounterBlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
