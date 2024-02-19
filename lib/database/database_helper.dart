import 'package:sqflite/sqflite.dart';
import 'package:take_note/database/database_connection.dart';

class DatabaseHelper {
  late DatabaseConnection _databaseConnection;

  DatabaseHelper() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  Future<int?> insertData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  Future<int?> deleteData(String table, String id) async {
    var connection = await database;
    return await connection?.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> updateData(
      String table, Map<String, dynamic> data, String id) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>?> getData(String table) async {
    var connection = await database;
    return await connection?.query(table);
  }
}
