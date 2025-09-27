import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MusicDatabase {
  static final MusicDatabase instance = MusicDatabase._init();

  static Database? _database;

  MusicDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('musicplayer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Playlist table
    await db.execute('''
      CREATE TABLE playlists(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // Playlist songs join table
    await db.execute('''
      CREATE TABLE playlist_songs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        song_id INTEGER NOT NULL,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id)
      )
    ''');

    // Favourites table
    await db.execute('''
      CREATE TABLE favourites(
        song_id INTEGER PRIMARY KEY
      )
    ''');

    // Recent plays
    await db.execute('''
      CREATE TABLE recent_plays(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        song_id INTEGER NOT NULL,
        played_at INTEGER NOT NULL
      )
    ''');
  }

  // Close DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
