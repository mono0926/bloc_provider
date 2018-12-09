import 'dart:ui' show Color;

import 'package:meta/meta.dart';

@immutable
class Product {
  final int id;

  final String name;

  final Color color;

  const Product(this.id, this.name, this.color);

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) => other is Product && other.hashCode == hashCode;

  @override
  String toString() => '$name (id=$id)';
}
