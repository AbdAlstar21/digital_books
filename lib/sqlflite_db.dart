import 'package:digital_books/pages/books/books_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class sqlfliteDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'download.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
            'CREATE TABLE downloads (id INTEGER PRIMARY KEY, name TEXT, lang TEXT, file TEXT, nump INTEGER, size int, parasize TEXT, dat TEXT)'
      // '''
      // CREATE TABLE downloads(book_id NOT NULL INTEGER PRIMARY KEY AUTOINCREMENT, book_name TEXT NOT NULL , book_lang TEXT NOT NULL , book_file TEXT NOT NULL)
      // '''
      );
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    await db.execute('''

      ''');
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  upData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'download.db');
    await deleteDatabase(path);
  }
  

}
