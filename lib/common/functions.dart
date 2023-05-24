import 'dart:io';

import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

List<GridColumn> generateColumns(FormatModel format) {
  List<GridColumn> ret = [];
  ret.add(GridColumn(
    columnName: 'id',
    label: const CustomColumnLabel('ID'),
  ));
  int itemKey = 1;
  for (Map<String, String> map in format.items) {
    String columnName = 'column$itemKey';
    ret.add(
      GridColumn(
        columnName: columnName,
        label: CustomColumnLabel('${map['name']}'),
      ),
    );
    itemKey++;
  }
  if (format.type != 'csv') {
    ret.add(GridColumn(
      columnName: 'path',
      label: const CustomColumnLabel('ファイル'),
    ));
  }
  return ret;
}

List<DataGridCell<dynamic>> generateCells(
  FormatModel format,
  Map<String, dynamic> backup,
) {
  List<DataGridCell<dynamic>> ret = [];
  ret.add(DataGridCell(columnName: 'id', value: backup['id']));
  int itemKey = 1;
  for (Map<String, String> map in format.items) {
    String columnName = 'column$itemKey';
    ret.add(DataGridCell(
      columnName: columnName,
      value: backup[columnName],
    ));
    itemKey++;
  }
  if (format.type != 'csv') {
    ret.add(DataGridCell(
      columnName: 'path',
      value: backup['path'],
    ));
  }
  return ret;
}

Future<XFile?> getFile(FormatModel format) async {
  XFile? ret;
  XTypeGroup group = const XTypeGroup(
    label: '全てのファイル',
    extensions: ['*'],
  );
  switch (format.type) {
    case 'csv':
      group = const XTypeGroup(
        label: 'CSVファイル',
        extensions: ['csv'],
      );
      break;
    case 'pdf':
      group = const XTypeGroup(
        label: 'PDFファイル',
        extensions: ['pdf'],
      );
      break;
    case 'img':
      group = const XTypeGroup(
        label: '画像ファイル',
        extensions: ['jpg', 'png'],
      );
      break;
  }
  XFile? file = await openFile(acceptedTypeGroups: [group]);
  ret = file;
  return ret;
}

Future insertBackup({
  required BackupService backupService,
  required FormatModel format,
  required XFile file,
  required List<Map<String, String>> addData,
}) async {
  switch (format.type) {
    case 'csv':
      String csvText = await file.readAsString();
      List<List<String>> csvData = [];
      int lineCount = 0;
      for (String line in csvText.split('\n')) {
        if (lineCount != 0 && line != '') {
          List<String> rows = line.split(',');
          csvData.add(rows);
        }
        lineCount++;
      }
      for (List<String> data in csvData) {
        data.add('');
        await backupService.insert(
          tableName: '${format.type}${format.id}',
          format: format,
          data: data,
        );
      }
      break;
    case 'pdf':
      final dir = await getApplicationDocumentsDirectory();
      dir.path;
      String savedPath = '${dir.path}/${p.basename(file.path)}';
      File savedFile = File(savedPath);
      await savedFile.writeAsBytes(await file.readAsBytes());
      List<String> data = [];
      for (Map<String, String> map in addData) {
        data.add(map['value'].toString());
      }
      data.add(savedPath);
      await backupService.insert(
        tableName: '${format.type}${format.id}',
        format: format,
        data: data,
      );
      break;
    case 'img':
      final dir = await getApplicationDocumentsDirectory();
      dir.path;
      String savedPath = '${dir.path}/${p.basename(file.path)}';
      File savedFile = File(savedPath);
      await savedFile.writeAsBytes(await file.readAsBytes());
      List<String> data = [];
      for (Map<String, String> map in addData) {
        data.add(map['value'].toString());
      }
      data.add(savedPath);
      await backupService.insert(
        tableName: '${format.type}${format.id}',
        format: format,
        data: data,
      );
      break;
  }
  return;
}
