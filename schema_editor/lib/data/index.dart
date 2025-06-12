class Key {
  List<String> key;

  Key(this.key);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Key && _listEquals(key, other.key));

  @override
  int get hashCode => Object.hashAll(key);

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

typedef Row = List<String>;

class Index {
  final Map<Key, List<Row>> _data;

  Index() : _data = {};

  void add(Key key, Row row) {
    _data.update(key, (v) => v..add(row), ifAbsent: () => [row]);
  }

  List<Row> getRows(Key key) => _data[key] ?? [];

  List<({Key key, List<Row> rows})> data() {
    return _data.entries.map((e) => (key: e.key, rows: e.value)).toList();
  }
}
