import 'package:data_chest_exe/models/log.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LogService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<List<LogModel>> select() async {
    try {
      Database db = await _getDatabase();
      List<Map> listMap = await db.rawQuery('select * from log');
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

  Future<String?> update({
    required int id,
    required String memo,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawUpdate('''
        update log
        set memo = '$memo'
        where id = $id;
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
