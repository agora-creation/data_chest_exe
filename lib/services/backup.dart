import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BackupService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future create({
    required String tableName,
    required List<Map<String, String>> items,
  }) async {
    try {
      Database db = await _getDatabase();
      String sql =
          'CREATE TABLE `$tableName` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
      int itemKey = 1;
      for (Map<String, String> map in items) {
        String columnName = 'column$itemKey';
        sql += '`$columnName` ${map['type']},';
        itemKey++;
      }
      sql += '`path` TEXT,';
      sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
      await db.execute(sql);
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<Map<String, dynamic>>> select({
    required String tableName,
    required List<Map<String, String>> searchData,
  }) async {
    try {
      Database db = await _getDatabase();
      String sql = 'select * from $tableName where id != 0';
      int itemKey = 1;
      for (Map<String, String> map in searchData) {
        String columnName = 'column$itemKey';
        if (map['value'] != '') {
          sql += " and $columnName like '%${map['value']}%'";
        }
        itemKey++;
      }
      sql += ' order by createdAt DESC';
      List<Map<String, dynamic>> listMap = await db.rawQuery(sql);
      return listMap;
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> insert({
    required String tableName,
    required FormatModel format,
    required List<String> data,
  }) async {
    try {
      Database db = await _getDatabase();
      String columnSql = '';
      String valuesSql = '';
      int itemKey = 1;
      for (Map<String, String> map in format.items) {
        String columnName = 'column$itemKey';
        if (columnSql != '') columnSql += ',';
        columnSql += columnName;
        if (valuesSql != '') valuesSql += ',';
        valuesSql += "'${data[itemKey - 1]}'";
        itemKey++;
      }
      columnSql += ',path';
      valuesSql += ",'${data[itemKey - 1]}'";
      int newId = await db.rawInsert(
        'insert into $tableName ( $columnSql ) values ( $valuesSql );',
      );
      return newId;
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> delete({required String tableName}) async {
    try {
      Database db = await _getDatabase();
      int flg = await db.delete(tableName);
      if (flg == 1) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception();
    }
  }
}
