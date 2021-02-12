import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';

import 'counter_bloc.dart';

class CounterBlocProvider extends BlocProvider<CounterBloc> {
  CounterBlocProvider({
    required Widget child,
  }) : super(
          child: child,
          creator: (context, _bag) {
            return CounterBloc();
          },
        );

  static CounterBloc of(BuildContext context) => BlocProvider.of(context);
}
