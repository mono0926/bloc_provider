import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: PositionedTiles()));

class PositionedTiles extends StatefulWidget {
  @override
  _PositionedTilesState createState() => _PositionedTilesState();
}

class _PositionedTilesState extends State<PositionedTiles> {
  late final List<Widget> tiles;

  @override
  void initState() {
    super.initState();
    // Works well
//    tiles = [
//      StatelessTile(title: 'A'),
//      StatelessTile(title: 'B'),
//    ];
    // Not work
//    tiles = [
//      StatefulTile(title: 'A'),
//      StatefulTile(title: 'B'),
//    ];
    // Works well
    tiles = [
      const StatefulTile(title: 'A', key: Key('A')),
      const StatefulTile(title: 'B', key: Key('B')),
    ];

    // Not work if BlocProvider's key is omitted.
//    tiles = [
//      BlocTile(title: 'A'),
//      BlocTile(title: 'B'),
//    ];

    // Works well even if BlocProvider's key is omitted.
//    tiles = [
//      BlocTile(title: 'A', key: Key('A')),
//      BlocTile(title: 'B', key: Key('B')),
//    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build tiles: $tiles');
    return Scaffold(
      body: SafeArea(child: Column(children: tiles)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tiles.insert(1, tiles.removeAt(0));
          });
        },
        child: const Icon(Icons.sentiment_very_satisfied),
      ),
    );
  }
}

class StatelessTile extends StatelessWidget {
  final String title;

  const StatelessTile({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
      height: 44,
      padding: const EdgeInsets.all(16),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return 'tile($title)';
  }
}

class StatefulTile extends StatefulWidget {
  final String title;

  const StatefulTile({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  StatefulTileState createState() => StatefulTileState(title: title);
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return 'tile($title)';
  }
}

class StatefulTileState extends State<StatefulTile> {
  final String title;

  StatefulTileState({required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
      height: 44,
      padding: const EdgeInsets.all(16),
    );
  }

  @override
  void dispose() {
    print('disposed: $title');
    super.dispose();
  }
}

class BlocTile extends StatelessWidget {
  final String title;

  const BlocTile({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TitleBloc>.builder(
      key: Key(title),
      creator: (context, _bag) {
        return TitleBloc(title);
      },
      builder: (context, bloc) {
        return Container(
          child: Text(bloc.title),
          height: 44,
          padding: const EdgeInsets.all(16),
        );
      },
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return 'tile($title)';
  }
}

class TitleBloc implements Bloc {
  final String title;

  TitleBloc(this.title);
  @override
  void dispose() {
    print('disposed: bloc $title');
  }
}
