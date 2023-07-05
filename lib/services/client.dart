import 'package:data_chest_exe/models/client.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ClientService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<List<ClientModel>> select({
    required Map<String, String> searchMap,
  }) async {
    try {
      Database db = await _getDatabase();
      String sql = 'select * from client where id != 0';
      if (searchMap['code'] != '') {
        sql += " and code like '%${searchMap['code']}%'";
      }
      if (searchMap['name'] != '') {
        sql += " and name like '%${searchMap['name']}%'";
      }
      sql += ' order by id ASC';
      List<Map> listMap = await db.rawQuery(sql);
      return ClientModel.fromSQLiteList(listMap);
    } catch (e) {
      throw Exception();
    }
  }

  Future<String?> insert({
    required String code,
    required String name,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawInsert('''
        insert into client (
          code,
          name
        ) values (
          '$code',
          '$name',
        );
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> update({
    required int id,
    required String code,
    required String name,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawUpdate('''
        update client
        set code = '$code', name = '$name'
        where id = $id;
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> delete({
    required int id,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawDelete(
        'delete from client where id = $id;',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
