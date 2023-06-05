import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ConnectionSQLiteService {
  ConnectionSQLiteService._();

  static ConnectionSQLiteService? _instance;

  static ConnectionSQLiteService get instance {
    _instance ??= ConnectionSQLiteService._();
    return _instance!;
  }

  static const DATABASE_NAME = 'data_chest20230606.db';
  static const DATABASE_VERSION = 1;
  Database? _db;

  Future<Database> get db => _openDatabase();

  Future<Database> _openDatabase() async {
    sqfliteFfiInit();
    final dbDirectory = await getApplicationSupportDirectory();
    final dbFilePath = dbDirectory.path;
    String path = join(dbFilePath, DATABASE_NAME);
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    _db ??= await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        onCreate: _onCreate,
        version: DATABASE_VERSION,
      ),
    );
    return _db!;
  }

  FutureOr<void> _onCreate(Database db, int version) {
    db.transaction((reference) async {
      await reference.execute('''
        CREATE TABLE `format` (
          `id` INTEGER PRIMARY KEY AUTOINCREMENT,
          `title` TEXT,
          `remarks` TEXT,
          `type` TEXT,
          `items` TEXT,
          `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
      ''');
      await reference.execute('''
        CREATE TABLE `log` (
          `id` INTEGER PRIMARY KEY AUTOINCREMENT,
          `content` TEXT,
          `memo` TEXT,
          `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
      ''');
      _initGeneration(reference);
    });
  }

  Future _initGeneration(Transaction reference) async {
    List<Map<String, String>> items = [];
    items.add({'name': 'カテゴリコード', 'type': 'TEXT'});
    items.add({'name': '商品コード', 'type': 'TEXT'});
    items.add({'name': '商品名', 'type': 'TEXT'});
    items.add({'name': '商品カナ名', 'type': 'TEXT'});
    items.add({'name': '入数', 'type': 'INTEGER'});
    items.add({'name': '商品説明文', 'type': 'TEXT'});
    items.add({'name': '状態フラグ', 'type': 'INTEGER'});
    items.add({'name': 'JANコード', 'type': 'TEXT'});
    int id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '注文データ',
        '',
        'csv',
        '${json.encode(items)}'
      );
    ''');
    String sql =
        'CREATE TABLE `csv$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    int itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
    items.clear();
    items.add({'name': '見積日', 'type': 'DATETIME'});
    items.add({'name': '見積No', 'type': 'TEXT'});
    items.add({'name': '件名', 'type': 'TEXT'});
    items.add({'name': '納期', 'type': 'DATETIME'});
    items.add({'name': '支払条件', 'type': 'TEXT'});
    items.add({'name': '有効期限', 'type': 'TEXT'});
    items.add({'name': '見積金額', 'type': 'TEXT'});
    items.add({'name': '発行会社名', 'type': 'TEXT'});
    items.add({'name': '発行会社住所', 'type': 'TEXT'});
    id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '見積書',
        '',
        'pdf',
        '${json.encode(items)}'
      );
    ''');
    sql = 'CREATE TABLE `pdf$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
    items.clear();
    items.add({'name': '発注日', 'type': 'DATETIME'});
    items.add({'name': '発注No', 'type': 'TEXT'});
    items.add({'name': '件名', 'type': 'TEXT'});
    items.add({'name': '納期', 'type': 'DATETIME'});
    items.add({'name': '支払条件', 'type': 'TEXT'});
    items.add({'name': '発注金額', 'type': 'TEXT'});
    items.add({'name': '発行会社名', 'type': 'TEXT'});
    items.add({'name': '発行会社住所', 'type': 'TEXT'});
    id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '発注書',
        '',
        'pdf',
        '${json.encode(items)}'
      );
    ''');
    sql = 'CREATE TABLE `pdf$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
    items.clear();
    items.add({'name': '納品日', 'type': 'DATETIME'});
    items.add({'name': '納品No', 'type': 'TEXT'});
    items.add({'name': '件名', 'type': 'TEXT'});
    items.add({'name': '納期', 'type': 'DATETIME'});
    items.add({'name': '支払条件', 'type': 'TEXT'});
    items.add({'name': '納品金額', 'type': 'TEXT'});
    items.add({'name': '発行会社名', 'type': 'TEXT'});
    items.add({'name': '発行会社住所', 'type': 'TEXT'});
    id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '納品書',
        '',
        'pdf',
        '${json.encode(items)}'
      );
    ''');
    sql = 'CREATE TABLE `pdf$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
    items.clear();
    items.add({'name': '受領日', 'type': 'DATETIME'});
    items.add({'name': '受領No', 'type': 'TEXT'});
    items.add({'name': '受領会社名', 'type': 'TEXT'});
    items.add({'name': '件名', 'type': 'TEXT'});
    items.add({'name': '納品日', 'type': 'DATETIME'});
    items.add({'name': '支払条件', 'type': 'TEXT'});
    items.add({'name': '金額', 'type': 'TEXT'});
    items.add({'name': '発行会社名', 'type': 'TEXT'});
    items.add({'name': '発行会社住所', 'type': 'TEXT'});
    id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '受領書',
        '',
        'pdf',
        '${json.encode(items)}'
      );
    ''');
    sql = 'CREATE TABLE `pdf$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
    items.clear();
    items.add({'name': '請求日', 'type': 'DATETIME'});
    items.add({'name': '請求No', 'type': 'TEXT'});
    items.add({'name': '件名', 'type': 'TEXT'});
    items.add({'name': '支払期限', 'type': 'DATETIME'});
    items.add({'name': '振込先', 'type': 'TEXT'});
    items.add({'name': '金額', 'type': 'TEXT'});
    items.add({'name': '発行会社名', 'type': 'TEXT'});
    items.add({'name': '発行会社住所', 'type': 'TEXT'});
    id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '請求書',
        '',
        'pdf',
        '${json.encode(items)}'
      );
    ''');
    sql = 'CREATE TABLE `pdf$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
    items.clear();
    items.add({'name': '発行日', 'type': 'DATETIME'});
    items.add({'name': '領収No', 'type': 'TEXT'});
    items.add({'name': '宛名', 'type': 'TEXT'});
    items.add({'name': '金額', 'type': 'TEXT'});
    items.add({'name': '但', 'type': 'TEXT'});
    id = await reference.rawInsert('''
      insert into format (
        title,
        remarks,
        type,
        items
      ) values (
        '領収書',
        '',
        'pdf',
        '${json.encode(items)}'
      );
    ''');
    sql = 'CREATE TABLE `pdf$id` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT,';
    itemKey = 1;
    for (Map<String, String> map in items) {
      String columnName = 'column$itemKey';
      sql += '`$columnName` ${map['type']},';
      itemKey++;
    }
    sql += '`path` TEXT,';
    sql += '`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );';
    await reference.execute(sql);
    //----------------------------------------
  }
}
