import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:csv_armor/src/require.dart';

class IndexKey implements Comparable<IndexKey> {
  IndexKey(this.key);

  final List<String> key;

  @override
  bool operator ==(Object other) =>
      other is IndexKey && const ListEquality<String>().equals(key, other.key);

  @override
  int get hashCode => const ListEquality<String>().hash(key);

  @override
  String toString() => key.toString();

  @override
  int compareTo(IndexKey other) {
    for (int i = 0; i < min(key.length, other.length); ++i) {
      final cmp = key[i].compareTo(other[i]);
      if (cmp != 0) {
        return cmp;
      }
    }
    return key.length.compareTo(other.length);
  }

  int get length => key.length;

  String operator [](int index) => key[index];
}

class Index {
  Index.build(List<int> keyColumnIndex, List<List<String>> records)
      : _data = {} {
    require(keyColumnIndex.isNotEmpty, ["keyColumnIndex"],
        "keyColumnIndex must be not empty");
    require(keyColumnIndex.toSet().length == keyColumnIndex.length,
        ["keyColumnIndex"], "each index in keyColumnIndex must be unique");
    require(
        keyColumnIndex.every((i) => 0 <= i && i < records.length),
        ["keyColumnIndex", "records"],
        "each index in keyColumnIndex must be in [0, records.length)");
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

  List<IndexKey> collectKeys() => _data.keys.toList()..sort();
}
