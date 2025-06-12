import 'package:test/test.dart';
import 'package:schema_editor/data/index.dart';

void main() {
  group('Index', () {
    late Index index;
    setUp(() {
      index = Index();
    });

    test('add and getRows', () {
      final key1 = Key(['key1']);
      final row1 = ['a', 'b', 'c'];
      final row2 = ['d', 'e', 'f'];
      index.add(key1, row1);
      index.add(key1, row2);
      expect(index.getRows(key1), equals([row1, row2]));
    });

    test('getRows returns empty list for missing key', () {
      expect(index.getRows(Key(['missing'])), isEmpty);
    });

    test('data returns all key-row pairs', () {
      final key1 = Key(['key1']);
      final key2 = Key(['key2']);
      final row1 = ['a', 'b'];
      final row2 = ['c', 'd'];
      index.add(key1, row1);
      index.add(key2, row2);
      final data = index.data();
      expect(
        data.any((e) => e.key == key1 && e.rows.length == 1 && e.rows[0] == row1),
        isTrue,
        reason: 'Should contain key1 with row1',
      );
      expect(
        data.any((e) => e.key == key2 && e.rows.length == 1 && e.rows[0] == row2),
        isTrue,
        reason: 'Should contain key2 with row2',
      );
    });
  });
}
