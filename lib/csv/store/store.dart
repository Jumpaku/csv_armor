import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';

class PrimaryKey implements Comparable<PrimaryKey> {
  PrimaryKey(this.primaryKey);

  final List<String> primaryKey;

  @override
  bool operator ==(Object other) =>
      other is PrimaryKey && primaryKey.equals(other.primaryKey);

  @override
  int get hashCode => primaryKey.hashCode;

  @override
  String toString() => primaryKey.toString();

  @override
  int compareTo(PrimaryKey other) {
    for (int i = 0; i < min(primaryKey.length, other.length); ++i) {
      final cmp = primaryKey[i].compareTo(other[i]);
      if (cmp != 0) {
        return cmp;
      }
    }
    return primaryKey.length.compareTo(other.length);
  }

  int get length => primaryKey.length;

  String operator [](int index) => primaryKey[index];
}

typedef ColumnID = int;

class Store {
  Store(
    List<String> columns,
    List<int> primaryKeyIndex, {
    List<List<String>> data = const [],
  })  : _nextColumnID = columns.length,
        _columnByID = {
          for (final (index, name) in columns.indexed)
            index: (name: name, index: index),
        },
        _columnIDByName = {
          for (final (index, name) in columns.indexed) name: index,
        },
        _columnIDByIndex = [for (final (index, _) in columns.indexed) index],
        _primaryKey = [...primaryKeyIndex],
        _data = SplayTreeMap.from({
          for (final row in data)
            PrimaryKey([for (final index in primaryKeyIndex) row[index]]): {
              for (final (index, value) in row.indexed) index: value,
            },
        }) {
    if (columns.isEmpty) {
      throw ArgumentError('columns must not be empty', 'columns');
    }
    if (primaryKeyIndex.isEmpty) {
      throw ArgumentError(
          'primaryKeyIndex must not be empty', 'primaryKeyIndex');
    }
    if (columns.toSet().length != columns.length) {
      throw ArgumentError('columns must be unique', 'columns');
    }
    if (primaryKeyIndex.toSet().length != primaryKeyIndex.length) {
      throw ArgumentError('primaryKeyIndex must be unique', "primaryKeyIndex");
    }
    if (primaryKeyIndex.where((i) => i < 0 || i >= columns.length).isNotEmpty) {
      throw ArgumentError('primaryKeyIndex must be a subset of columns indices',
          'primaryKeyIndex');
    }
    if (data.where((row) => row.length != columns.length).isNotEmpty) {
      throw ArgumentError(
          'All rows must have the same length with columns', 'data');
    }
    if (data.length != _data.length) {
      throw ArgumentError('primary key duplicated', 'data');
    }
  }

  int _nextColumnID = 0;
  List<ColumnID> _primaryKey;
  Map<ColumnID, ({String name, int index})> _columnByID;
  Map<String, ColumnID> _columnIDByName;
  List<ColumnID> _columnIDByIndex;
  SplayTreeMap<PrimaryKey, Map<ColumnID, String>> _data;

  List<List<String>> listRecords() {
    return _data.values.map((recordData) {
      return _columnIDByIndex.map((id) => recordData[id] ?? "").toList();
    }).toList();
  }

  List<String>? findRecord(PrimaryKey pk) {
    if (pk.length != _primaryKey.length) {
      throw ArgumentError('pk must have the same length with primaryKey', 'pk');
    }
    final recordData = _data[pk];
    if (recordData == null) {
      return null;
    }

    return _columnIDByIndex.map((id) => recordData[id] ?? "").toList();
  }

  upsertRecord(List<String> record) {
    if (record.length != _columnIDByIndex.length) {
      throw ArgumentError(
          'record must have the same length with columns', 'record');
    }
    final pkIndex = _primaryKey.map((id) => _columnByID[id]!.index);
    final pk = PrimaryKey(pkIndex.map((i) => record[i]).toList());
    _data[pk] = {
      for (final (index, id) in _columnIDByIndex.indexed) id: record[index]
    };
  }

  deleteRecord(PrimaryKey pk) {
    if (pk.length != _primaryKey.length) {
      throw ArgumentError('pk must have the same length with primaryKey', 'pk');
    }
    _data.remove(pk);
  }

  reorderColumns(List<String> reorderedColumns) {
    if (reorderedColumns.length != _columnIDByName.length ||
        !_columnIDByName.keys.toSet().containsAll(reorderedColumns)) {
      throw ArgumentError(
          'reorderedColumns must be a permutation of column names',
          'reorderedColumns');
    }
    final reordered = [..._columnIDByIndex];
    for (final (index, name) in reorderedColumns.indexed) {
      reordered[index] = _columnIDByName[name]!;
    }
    _columnIDByIndex = reordered;
    _columnByID = {
      for (final (index, id) in _columnIDByIndex.indexed)
        id: (name: _columnByID[id]!.name, index: index)
    };
  }

  updateColumn(String nameBefore, String nameAfter) {
    if (!_columnIDByName.containsKey(nameBefore)) {
      throw ArgumentError('Column not found: $nameBefore', 'nameBefore');
    }
    if (nameBefore == nameAfter) {
      return;
    }
    if (_columnIDByName.containsKey(nameAfter)) {
      throw ArgumentError('Column already exists: $nameAfter', 'nameAfter');
    }

    final id = _columnIDByName[nameBefore]!;
    _columnIDByName.remove(nameBefore);

    final (name: _, index: index) = _columnByID[id]!;
    _columnByID[id] = (name: nameAfter, index: index);
    _columnIDByName[nameAfter] = id;
  }

  insertColumn(String name) {
    if (_columnIDByName.containsKey(name)) {
      throw ArgumentError('Column already exists: $name', 'name');
    }
    final id = _nextColumnID++;
    _columnByID[id] = (name: name, index: _columnByID.length);
    _columnIDByName[name] = id;
    _columnIDByIndex.add(id);
  }

  deleteColumn(String name) {
    if (!_columnIDByName.containsKey(name)) {
      return;
    }
    if (_primaryKey.contains(_columnIDByName[name]!)) {
      throw Exception('Cannot delete primary key column');
    }

    final id = _columnIDByName[name]!;
    _columnIDByName.remove(name);
    _columnIDByIndex = _columnIDByIndex..remove(id);
    _columnByID = {
      for (final (index, id) in _columnIDByIndex.indexed)
        id: (name: _columnByID[id]!.name, index: index)
    };
  }

  List<String> get columns =>
      _columnIDByIndex.map((id) => _columnByID[id]!.name).toList();

  PrimaryKey get primaryKey =>
      PrimaryKey(_primaryKey.map((id) => _columnByID[id]!.name).toList());
}
