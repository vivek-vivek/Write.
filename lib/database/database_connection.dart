import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'take_note_db');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql = "CREATE TABLE notes ("
        "id INTEGER PRIMARY KEY,"
        "note TEXT,"
        "mood TEXT,"
        "updatedAt TEXT"
        ");";
    await database.execute(sql);
  }
}
