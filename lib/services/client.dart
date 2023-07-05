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

  Future<bool> _duplicateCheck(String code) async {
    try {
      Database db = await _getDatabase();
      String sql = "select * from client where code = '$code'";
      List<Map> listMap = await db.rawQuery(sql);
      if (listMap.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> insert({
    required String code,
    required String name,
  }) async {
    String? error;
    if (code == '') return '取引先コードを入力してください';
    if (name == '') return '取引先名を入力してください';
    if (await _duplicateCheck(code)) {
      return '取引先コードが重複しています';
    }
    try {
      Database db = await _getDatabase();
      await db.rawInsert('''
        insert into client (
          code,
          name
        ) values (
          '$code',
          '$name'
        );
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> update({
    required int id,
    required String name,
  }) async {
    String? error;
    if (name == '') return '取引先名を入力してください';
    try {
      Database db = await _getDatabase();
      await db.rawUpdate('''
        update client
        set name = '$name'
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
