import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';

enum AppTheme { dark, light }

class ThemeBloc extends Bloc {
  static var _currentTheme = AppTheme.light;
  final _themeController = StreamController<AppTheme>()..add(_currentTheme);
  get theme => _themeController.stream;

  void changeTheme() {
    _currentTheme =
        (_currentTheme == AppTheme.dark) ? AppTheme.light : AppTheme.dark;
    _themeController.add(_currentTheme);
  }

  @override
  void dispose() {
    _themeController.close();
  }
}
