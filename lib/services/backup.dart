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
      sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
      await db.execute(sql);
    } catch (e) {
      throw Exception();
    }
  }

  Future insert({
    required String tableName,
    required List<Map<String, String>> items,
  }) async {
    try {} catch (e) {
      throw Exception();
    }
  }

  Future update({
    required String tableName,
    required List<Map<String, String>> items,
  }) async {
    try {} catch (e) {
      throw Exception();
    }
  }

  Future<List<Map<String, dynamic>>> select({required String tableName}) async {
    try {
      Database db = await _getDatabase();
      List<Map<String, dynamic>> listMap =
          await db.rawQuery('select * from $tableName');
      return listMap;
    } catch (e) {
      throw Exception();
    }
  }
}
