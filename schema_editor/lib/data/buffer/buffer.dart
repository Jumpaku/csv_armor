import 'dart:collection';

typedef TableData = ({List<String> columns, List<List<String>> records});

class DataBuffer extends UnmodifiableMapView<String, TableData> {
  DataBuffer(Map<String, TableData> tableData) : super(tableData);
}
