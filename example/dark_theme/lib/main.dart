import 'package:bloc_provider/bloc_provider.dart';
import 'package:dark_theme_example/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'bloc/theme_bloc.dart';

void main() => runApp(BlocProvider<ThemeBloc>(
      creator: (context, bag) => ThemeBloc(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ThemeBloc>(context);
    return StreamBuilder(
      stream: bloc.theme,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData.dark(),
          home: HomePage(title: 'Flutter Demo Home Page'),
          themeMode: (snapshot.data == AppTheme.dark)
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}
