import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Типы данных таблиц базы данных
const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
const textType = 'TEXT';
const realType = 'REAL NOT NULL';
const integerType = 'INTEGER NOT NULL';

final DatabaseHelper instance = DatabaseHelper._init();

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  int versionBD = 1;
  String nameBD = 'WPCarDB_0001.db';
  String nameAssetsBD = 'WPCarDB_0001_assets.db';

  DatabaseHelper._init();

  get versionDB {
    return versionBD;
  }

  get nameDB {
    return nameBD;
  }

  Future<Database> get database async {
    if (_database != null) {
      if(!_database!.isOpen){
        _database = await _initDB();
      }
      return _database!;
    }

    _database = await _initDB();

    return _database!;
  }

  ///***********************************************
  /// Внутрішні функції та процедури
  ///***********************************************

  Future<Database> _initDB() async {
    /// Set name DB: from file or from assets
    String pathDB = await generatePathDB();

    /// Open database
    return await openDatabase(pathDB,
        version: versionDB, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _upgradeDB(Database db, int oldV, int newV) async {
    ///*******************************************************
    /// Не забувайте змінювати версію бази даних як константу!
    ///*******************************************************

    if (oldV <= 1) {

    }
  }

  Future _createDB(Database db, int version) async {

  }

  ///***********************************************
  /// Зовнішні функції та процедури
  ///***********************************************

  Future generatePathDB() async {
    /// Saved settings
    //final SharedPreferences prefs = await _prefs;
    //var useTestData = prefs.getBool('settings_useTestData') ?? false;

    /// Database catalog on device
    var catalogPath = await getDatabasesPath();
    var pathDB = '';

    pathDB = join(catalogPath, nameDB); // Use real data from SQLite

    return pathDB;
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
