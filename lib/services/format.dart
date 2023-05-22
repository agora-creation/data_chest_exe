import 'dart:convert';

import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FormatService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<List<FormatModel>> select() async {
    try {
      Database db = await _getDatabase();
      List<Map> listMap = await db.rawQuery('select * from format');
      return FormatModel.fromSQLiteList(listMap);
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> insert({
    required String title,
    required String remarks,
    required String type,
    required List<Map<String, String>> items,
  }) async {
    try {
      Database db = await _getDatabase();
      int newId = await db.rawInsert('''
        insert into format (
          title,
          remarks,
          type,
          items
        ) values (
          '$title',
          '$remarks',
          '$type',
          '${json.encode(items)}'
        );
      ''');
      return newId;
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> delete({required int id}) async {
    try {
      Database db = await _getDatabase();
      int newId = await db.rawDelete(
        'delete from format where id = $id;',
      );
      if (newId > 0) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception();
    }
  }
}
