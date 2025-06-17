import 'dart:collection';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as path;
import 'package:schema_editor/csv/decoder/decode_exception.dart';
import 'package:schema_editor/csv/decoder/decoder.dart';
import 'package:schema_editor/csv/decoder/decoder_config.dart' as csv;
import 'package:schema_editor/data/buffer.dart';
import 'package:schema_editor/csv/csv_reader_exception.dart';
import 'package:schema_editor/schema/schema.dart';

class CsvReader {
  factory CsvReader.fromConfig(
      {required path.Context ctx,
      required String root,
      required DecodeConfig decoderConfig}) {
    final decoder = Decoder(csv.DecoderConfig(
      headerLines: decoderConfig.headerLines ?? 0,
      fieldSeparator: decoderConfig.fieldSeparator ?? ",",
      recordSeparator: {
        RecordSeparator.CRLF: csv.RecordSeparator.crlf,
        RecordSeparator.CR: csv.RecordSeparator.cr,
        RecordSeparator.LF: csv.RecordSeparator.lf,
        RecordSeparator.ANY: csv.RecordSeparator.any,
      }[decoderConfig.recordSeparator ?? csv.RecordSeparator.any]!,
      fieldQuote: csv.DecoderConfigQuote(
        leftQuote: decoderConfig.fieldQuote?.left ?? '"',
        leftQuoteEscape: decoderConfig.fieldQuote?.leftEscape ?? '""',
        rightQuote: decoderConfig.fieldQuote?.right ?? '"',
        rightQuoteEscape: decoderConfig.fieldQuote?.rightEscape ?? '""',
      ),
    ));
    return CsvReader(ctx: ctx, root: root, decoder: decoder);
  }

  CsvReader({
    required path.Context ctx,
    required String root,
    required Decoder decoder,
  })  : _ctx = ctx,
        _decoder = decoder,
        _root = ctx.canonicalize(root);

  final path.Context _ctx;
  final String _root;
  final Decoder _decoder;

  DataBuffer readAll(List<TableConfig> tableConfig) {
    Map<String, TableData> tableData = {};
    for (final t in tableConfig) {
      final columns = t.columns.map((c) => c.name).toList();
      final records = _readRecords(t.name, t.csvPath, columns);
      tableData[t.name] = (columns: columns, records: records);
    }

    return DataBuffer(tableData);
  }

  List<List<String>> _readRecords(
      String tableName, String schemaCsvPath, List<String> columns) {
    final (columnIndex: columnIndex, pathColumnCount: pathColumnCount) =
        _columnIndex(schemaCsvPath, columns);
    final csvGlob = schemaCsvPath.replaceAll(_csvPathPlaceholderRegExp, '*');

    List<File> csvFiles = _listCsvFiles(tableName, csvGlob);

    final records = <List<String>>[];
    for (final csvFile in csvFiles) {
      // Extract path values from csvPath
      List<String> pathValues = _extractPathValues(
          schemaCsvPath, _ctx.canonicalize(csvFile.path), pathColumnCount);

      // Decode CSV file
      final csvRecords = _decodeCsvValues(tableName, csvFile);

      for (final csvRecord in csvRecords) {
        final csvValues = csvRecord.fields.map((f) => f.value).toList();
        if (csvValues.length != columns.length - pathValues.length) {
          throw CsvReaderException(
            'CSV file "${csvFile.path}" has ${csvValues.length} values, but expected ${columns.length} based on table "$tableName".',
            CsvReaderException.codeFieldCountMismatch,
            tableName,
            csvFile.path,
            csvLine: csvRecord.end.line,
            csvColumn: csvRecord.end.column,
          );
        }
        final record = pathValues + csvValues;
        records.add([for (final k in columnIndex) record[k]]);
      }
    }

    return records;
  }

  ({List<int> columnIndex, int pathColumnCount}) _columnIndex(
      String csvPath, List<String> columns) {
    // Extract path columns from csvPath
    final pathColumns = <String>[];
    final matches = _csvPathPlaceholderRegExp.allMatches(csvPath);
    for (final match in matches) {
      final placeholder = match.group(0)!;
      final colName = placeholder.substring(1, placeholder.length - 1);
      pathColumns.add(colName);
    }

    // Extract csv columns from table config
    final csvColumns = <String>[];
    for (final col in columns) {
      if (!pathColumns.contains(col)) {
        csvColumns.add(col);
      }
    }
    final columnIndex = {
      for (final (i, c) in (pathColumns + csvColumns).indexed) c: i
    };

    return (
      columnIndex: [for (final col in columns) columnIndex[col]!],
      pathColumnCount: pathColumns.length,
    );
  }

  List<File> _listCsvFiles(String tableName, String csvPathGlob) {
    try {
      final glob = Glob(csvPathGlob, context: _ctx);
      final files = glob.listSync(root: _root).whereType<File>();
      final scoped = files.where((f) {
        final rel = _ctx.relative(_ctx.canonicalize(f.path), from: _root);
        return !rel.startsWith('..');
      });
      return scoped.toList();
    } catch (e) {
      throw CsvReaderException(
        'failed to find CSV files: glob="$csvPathGlob": ${e.toString()}',
        CsvReaderException.codeFileReadFailed,
        tableName,
        csvPathGlob,
      );
    }
  }

  List<String> _extractPathValues(
      String schemaCsvPath, String csvFilePath, int pathColumnCount) {
    final relativeCsvFilePath = _ctx.relative(csvFilePath, from: _root);
    final canonicalSchemaCsvPath =
        _ctx.canonicalize(_ctx.join(_root, schemaCsvPath));
    final relativeSchemaCsvPath =
        _ctx.relative(canonicalSchemaCsvPath, from: _root);
    final csvPathRegexp = relativeSchemaCsvPath.splitMapJoin(
      _csvPathPlaceholderRegExp,
      onMatch: (_) => r'([^*\/\[\]]*)',
      onNonMatch: (s) => RegExp.escape(s),
    );
    final match = RegExp('.*$csvPathRegexp\$').firstMatch(relativeCsvFilePath)!;
    final pathValues = [
      for (int i = 1; i <= match.groupCount; i++) match.group(i)!
    ];
    return pathValues.sublist(pathValues.length - pathColumnCount);
  }

  List<Record> _decodeCsvValues(String tableName, File csvFile) {
    String content;

    try {
      content = csvFile.readAsStringSync();
    } catch (e) {
      throw CsvReaderException(
        'failed to read file: table: "$tableName", path="${csvFile.path}": ${e.toString()}',
        CsvReaderException.codeFileReadFailed,
        tableName,
        csvFile.path,
      );
    }

    DecodeResult result;
    try {
      result = _decoder.decode(content);
    } catch (e) {
      if (e is DecodeException) {
        throw CsvReaderException(
          'failed to decode CSV file: table="$tableName", path="${csvFile.path}", line=${e.position.line}, line=${e.position.column}: ${e.toString()}',
          CsvReaderException.codeCsvDecodeFailed,
          tableName,
          csvFile.path,
          csvLine: e.position.line,
          csvColumn: e.position.column,
        );
      }
      rethrow;
    }

    return result.records;
  }
}

// <placeholder> := '[' <text> ']'
// <text> := character sequence excluding '[', ']', '/', and '*'
final _csvPathPlaceholderRegExp = RegExp(r'\[[^*\/\[\]]+\]');
