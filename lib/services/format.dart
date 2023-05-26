import 'dart:convert';

import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FormatService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;
  BackupService backupService = BackupService();

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

  Future<String?> insert({
    required String title,
    required String remarks,
    required String type,
    required List<Map<String, String>> items,
  }) async {
    String? error;
    if (title == '') return 'タイトルを入力してください';
    if (items.isEmpty) return '項目を一つ以上追加してください';
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert('''
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
      error = await backupService.create(
        tableName: '$type$id',
        items: items,
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> delete({required int id}) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawDelete(
        'delete from format where id = $id;',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
