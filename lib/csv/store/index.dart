import 'dart:collection';

import 'package:collection/collection.dart';

class IndexKey {
  IndexKey(this.key);

  final List<String> key;

  @override
  bool operator ==(Object other) =>
      other is IndexKey && const ListEquality<String>().equals(key, other.key);

  @override
  int get hashCode => const ListEquality<String>().hash(key);

  @override
  String toString() => key.toString();

  int get length => key.length;

  String operator [](int index) => key[index];
}

class Index {
  Index.build(List<int> keyColumnIndex, List<List<String>> records)
      : _data = {} {
    for (final (index, record) in records.indexed) {
      final key = [for (final i in keyColumnIndex) record[i]];
      _data.update(
        IndexKey(key),
        (v) => v..add(index),
        ifAbsent: () => {index},
      );
    }
  }

  final Map<IndexKey, Set<int>> _data;

  List<int> get(IndexKey key) => (_data[key]?.toList()?..sort()) ?? [];

  Set<IndexKey> collectKeys() => _data.keys.toSet();
}
