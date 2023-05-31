import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/models/log.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LogService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<List<LogModel>> select({
    required Map<String, String> searchMap,
  }) async {
    try {
      Database db = await _getDatabase();
      String sql = 'select * from log where id != 0';
      if (searchMap['createdAt'] != '') {
        List<DateTime?> values = stringToDates('${searchMap['createdAt']}');
        String start = dateText('yyyy-MM-dd', values.first);
        String end = dateText('yyyy-MM-dd', values.last);
        sql += " and createdAt BETWEEN '$start 00:00:00' AND '$end 23:59:59'";
      }
      if (searchMap['content'] != '') {
        sql += " and content like '%${searchMap['content']}%'";
      }
      sql += ' order by createdAt DESC';
      List<Map> listMap = await db.rawQuery(sql);
      return LogModel.fromSQLiteList(listMap);
    } catch (e) {
      throw Exception();
    }
  }

  Future<String?> insertFormat({
    required FormatModel format,
  }) async {
    String? error;
    String content = '『${format.paneTitle()}』のBOXと、その中のデータを全て削除しました。';
    try {
      Database db = await _getDatabase();
      await db.rawInsert('''
        insert into log (
          content,
          memo
        ) values (
          '$content',
          ''
        );
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> insertBackup({
    required FormatModel format,
    required Map<String, dynamic> backup,
  }) async {
    String? error;
    String content = '『${format.paneTitle()}』のBOX内の、以下のデータを削除しました。\n';
    String itemsText = '';
    for (Map<String, String> map in format.items) {
      if (itemsText != '') itemsText += ',';
      itemsText += '${map['name']}';
    }
    content += '$itemsText\n';
    String backupText = '';
    int itemKey = 1;
    for (Map<String, String> map in format.items) {
      String columnName = 'column$itemKey';
      if (backupText != '') backupText += ',';
      backupText += '${backup[columnName]}';
      itemKey++;
    }
    if (format.type != 'csv') {
      backupText += ',${backup['path']}';
    }
    content += backupText;
    try {
      Database db = await _getDatabase();
      await db.rawInsert('''
        insert into log (
          content,
          memo
        ) values (
          '$content',
          ''
        );
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future update({
    required int id,
    required String memo,
  }) async {
    Database db = await _getDatabase();
    await db.rawUpdate('''
        update log
        set memo = '$memo'
        where id = $id;
      ''');
  }
}
