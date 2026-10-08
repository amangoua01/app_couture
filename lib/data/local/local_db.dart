import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  factory LocalDb() => _instance;
  LocalDb._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ateliya_local.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // File d'attente pour la synchronisation
        await db.execute('''
          CREATE TABLE sync_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT UNIQUE NOT NULL,
            entity_type TEXT NOT NULL,
            operation TEXT NOT NULL,
            payload TEXT NOT NULL,
            files_payload TEXT,
            status TEXT DEFAULT 'PENDING',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        // Cache des clients
        await db.execute('''
          CREATE TABLE clients (
            uuid TEXT PRIMARY KEY,
            id INTEGER,
            nom TEXT,
            prenoms TEXT,
            numero TEXT,
            photo TEXT,
            synced INTEGER DEFAULT 0,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        // Cache des factures
        await db.execute('''
          CREATE TABLE factures (
            uuid TEXT PRIMARY KEY,
            id INTEGER,
            client_uuid TEXT,
            avance REAL,
            montant_total REAL,
            reste_argent REAL,
            synced INTEGER DEFAULT 0,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  Future<void> clearQueue() async {
    final db = await database;
    await db.delete('sync_queue', where: "status = 'SYNCED'");
  }
}
