import 'package:data_chest_exe/common/functions.dart';
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

  Future<String?> insert(String content) async {
    String? error;
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
