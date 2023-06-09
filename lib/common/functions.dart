import 'dart:convert';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

Future<int?> getPrefsInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future setPrefsInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<String?> getPrefsString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future setPrefsString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<bool?> getPrefsBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future setPrefsBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future removePrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

Future allRemovePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

void showMessage(BuildContext context, String msg, bool success) {
  displayInfoBar(context, builder: (context, close) {
    return InfoBar(
      title: Text(msg),
      severity:
          success == true ? InfoBarSeverity.success : InfoBarSeverity.error,
    );
  });
}

String dateText(String format, DateTime? date) {
  String ret = '';
  if (date != null) {
    ret = DateFormat(format, 'ja').format(date);
  }
  return ret;
}

List<GridColumn> generateColumns(FormatModel format) {
  List<GridColumn> ret = [];
  ret.add(GridColumn(
    columnName: '',
    label: const CustomColumnLabel(''),
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
  ret.add(const DataGridCell(columnName: '', value: ''));
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

Future<DateTime?> showDataPickerDialog(
  BuildContext context,
  DateTime? value,
) async {
  List<DateTime?>? results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
    ),
    dialogSize: const Size(325, 400),
    value: [value],
    borderRadius: BorderRadius.circular(8),
    dialogBackgroundColor: whiteColor,
  );
  return results?.first;
}

Future<List<DateTime?>?> showDataRangePickerDialog(
  BuildContext context,
  DateTime? startValue,
  DateTime? endValue,
) async {
  List<DateTime?>? results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
    ),
    dialogSize: const Size(325, 400),
    value: [startValue, endValue],
    borderRadius: BorderRadius.circular(8),
    dialogBackgroundColor: whiteColor,
  );
  return results;
}

String datesToString(List<DateTime?>? dateTimes) {
  String ret = '';
  if (dateTimes != null) {
    if (dateTimes.length == 2) {
      String start = dateText('yyyy-MM-dd', dateTimes.first);
      String end = dateText('yyyy-MM-dd', dateTimes.last);
      ret = '$start,$end';
    }
  }
  return ret;
}

List<DateTime?> stringToDates(String value) {
  List<DateTime?> ret = [null, null];
  if (value != '') {
    List<String> valueList = value.split(',');
    DateTime start = DateTime.parse(valueList.first);
    DateTime end = DateTime.parse(valueList.last);
    ret = [start, end];
  }
  return ret;
}

Future downloadCSV({
  required List<String> header,
  required List<List<String>> rows,
}) async {
  String fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.csv';
  String csv = const ListToCsvConverter().convert(
    [header, ...rows],
  );
  String bom = '\uFEFF';
  String csvText = bom + csv;
  csvText = csvText.replaceAll('[', '');
  csvText = csvText.replaceAll(']', '');
  String? path = await getSavePath(
    acceptedTypeGroups: [
      const XTypeGroup(
        label: 'csv',
        extensions: ['csv'],
      )
    ],
    suggestedName: fileName,
  );
  if (path == null) return;
  final data = const Utf8Encoder().convert(csvText);
  final file = XFile.fromData(data, mimeType: 'text/plain');
  await file.saveTo(path);
}

Future<bool> licenseCheck(String code) async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
  Map<String, dynamic> deviceInfoData = deviceInfo.toMap();
  http.Response resp = await http.post(
    Uri.parse('https://www.agora-c.com/data_chest/check.php'),
    body: {
      'mode': 'check',
      'code': code,
      'install_pc': deviceInfoData['computerName'],
      'install_ip': '',
    },
  );
  if (int.parse(resp.body) == 1) {
    return true;
  } else {
    return false;
  }
}
