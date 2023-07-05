import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BackupService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<String?> create({
    required String tableName,
    required List<Map<String, String>> items,
  }) async {
    String? error;
    if (items.isEmpty) return '項目を一つ以上追加してください';
    try {
      Database db = await _getDatabase();
      String sql =
          'CREATE TABLE `$tableName` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
      int itemKey = 1;
      for (Map<String, String> map in items) {
        String columnName = 'column$itemKey';
        if (map['type'] == 'CLIENT') {
          sql += '`$columnName` TEXT,';
        } else {
          sql += '`$columnName` ${map['type']},';
        }
        itemKey++;
      }
      sql += '`path` TEXT,';
      sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
      await db.execute(sql);
    } catch (e) {
      error = e.toString();
    }
    return error;
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
        if (map['type'] == 'TEXT') {
          if (map['value'] != '') {
            sql += " and $columnName like '%${map['value']}%'";
          }
        } else if (map['type'] == 'INTEGER') {
          if (map['value'] != '') {
            sql += " and $columnName = '${map['value']}'";
          }
        } else if (map['type'] == 'DATETIME') {
          if (map['value'] != '') {
            List<DateTime?> values = stringToDates('${map['value']}');
            String start = dateText('yyyy-MM-dd', values.first);
            String end = dateText('yyyy-MM-dd', values.last);
            sql +=
                " and $columnName BETWEEN '$start 00:00:00' AND '$end 23:59:59'";
          }
        } else if (map['type'] == 'CLIENT') {
          if (map['value'] != '') {
            sql += " and $columnName = '${map['value']}'";
          }
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

  Future<String?> insert({
    required String tableName,
    required FormatModel format,
    required List<String> data,
  }) async {
    String? error;
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
        String dataValue = '';
        if (map['type'] == 'TEXT') {
          dataValue = data[itemKey - 1];
        } else if (map['type'] == 'INTEGER') {
          if (int.tryParse(data[itemKey - 1]) != null) {
            dataValue = data[itemKey - 1];
          } else {
            dataValue = '0';
          }
        } else if (map['type'] == 'DATETIME') {
          if (data[itemKey - 1] != '') {
            DateTime tmp = DateTime.parse(data[itemKey - 1]);
            dataValue = dateText('yyyy-MM-dd', tmp);
          } else {
            dataValue = '0001-01-01';
          }
        } else if (map['type'] == 'CLIENT') {
          dataValue = data[itemKey - 1];
        }
        valuesSql += "'$dataValue'";
        itemKey++;
      }
      columnSql += ',path';
      valuesSql += ",'${data[itemKey - 1]}'";
      int id = await db.rawInsert(
        'insert into $tableName ( $columnSql ) values ( $valuesSql );',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> delete({
    required String tableName,
    required int id,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawDelete(
        'delete from $tableName where id = $id;',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> deleteAll({required String tableName}) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.delete(tableName);
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
