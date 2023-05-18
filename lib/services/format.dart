import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FormatService {
  ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<FormatModel> insert(FormatModel formatModel) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert('''
        insert into format (
          title,
          remarks,
          type,
          items
        ) values (
          '${formatModel.title}',
          '${formatModel.remarks}',
          '${formatModel.type}',
          '${formatModel.items}'
        );
      ''');
      formatModel.id = id;
      return formatModel;
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> update(FormatModel formatModel) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawUpdate('''
        update format set
        title = '${formatModel.title}',
        remarks = '${formatModel.remarks}',
        type = '${formatModel.type}',
        items = '${formatModel.items}'
        where id = ${formatModel.id};
      ''');
      if (id > 0) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception();
    }
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

  Future<bool> delete(FormatModel formatModel) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawDelete(
        'delete from format where id = ${formatModel.id};',
      );
      if (id > 0) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception();
    }
  }
}
