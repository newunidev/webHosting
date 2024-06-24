import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app.db');

    // Ensure the database directory exists
    await io.Directory(databasesPath).create(recursive: true);




    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(email TEXT PRIMARY KEY, password TEXT)");
  }

  Future<int> saveUser(String email, String password) async {
    var dbClient = await db;
    await dbClient.execute('DELETE FROM User');
    int res = await dbClient.insert("User", {"email": email, "password": "nooo"});
    return res;
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query("User",
        columns: ["email", "password"], where: 'email = ?', whereArgs: [email]);
    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  Future<int> deleteUser(String email) async {
    var dbClient = await db;
    return await dbClient
        .delete("User", where: 'email = ?', whereArgs: [email]);
  }

  Future<int> updateUser(String email, String password) async {
    var dbClient = await db;
    return await dbClient.update("User", {"password": password},
        where: 'email = ?', whereArgs: [email]);
  }
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query("User");
    return list;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
