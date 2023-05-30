import 'dart:async';

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

  static const DATABASE_NAME = 'data_chest.db';
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
      reference.execute('''
        CREATE TABLE `format` (
          `id` INTEGER PRIMARY KEY AUTOINCREMENT,
          `title` TEXT,
          `remarks` TEXT,
          `type` TEXT,
          `items` TEXT,
          `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
        CREATE TABLE `log` (
          `id` INTEGER PRIMARY KEY AUTOINCREMENT,
          `content` TEXT,
          `memo` TEXT,
          `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
      ''');
    });
  }
}
