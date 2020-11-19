import 'dart:io';
import 'package:contacts/model/contact_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    String dbPath = join(path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute(''' CREATE TABLE ${Contact.tableName} (
     ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
     ${Contact.colName} TEXT NOT NULL,
     ${Contact.colMobileNo} TEXT NOT NULL
   ) ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return db.insert(Contact.tableName, contact.toMap());
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tableName);
    return (contacts.length == 0)
        ? []
        : contacts.map((e) => Contact.formMap(e)).toList();
  }

  Future<List<Contact>> fetchContactsseq() async {
    Database db = await database;
    List<Map> contacts =
        await db.query(Contact.tableName, orderBy: '${Contact.colName} ASC');
    return (contacts.length == 0)
        ? []
        : contacts.map((e) => Contact.formMap(e)).toList();
  }

  deleteContact(int id) async {
    Database db = await database;
    return db.delete(Contact.tableName,
        where: '${Contact.colId}=?', whereArgs: [id]);
  }
}
