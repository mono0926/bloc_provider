import 'package:flutter/material.dart';

import 'bloc/counter_bloc_provider.dart';
import 'const.dart';
import 'page/counter_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CounterBlocProvider(
      child: MaterialApp(
        title: Const.title,
        home: CounterPage(),
      ),
    );
  }
}
