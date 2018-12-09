import 'package:flutter/widgets.dart';
import 'package:simple_bloc/bloc/counter_bloc.dart';

class CounterBlocProvider extends InheritedWidget {
  CounterBlocProvider({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final CounterBloc bloc;

  static CounterBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CounterBlocProvider)
            as CounterBlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(CounterBlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
