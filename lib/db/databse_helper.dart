import 'package:swaralipi/db/database_setup.dart';

class MusicRepository {
  final MusicDatabase db;

  MusicRepository(this.db);

  // Playlists
  Future<int> createPlaylist(String name) async {
    final dbClient = await db.database;
    return await dbClient.insert('playlists', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final dbClient = await db.database;
    return await dbClient.query('playlists');
  }

  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    final dbClient = await db.database;
    await dbClient.insert('playlist_songs', {
      'playlist_id': playlistId,
      'song_id': songId,
    });
  }

  Future<List<int>> getSongsInPlaylist(int playlistId) async {
    final dbClient = await db.database;
    final maps = await dbClient.query(
      'playlist_songs',
      columns: ['song_id'],
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );
    return maps.map((e) => e['song_id'] as int).toList();
  }

  // Favourites
  Future<void> addToFavourites(int songId) async {
    final dbClient = await db.database;
    await dbClient.insert('favourites', {'song_id': songId});
  }

  Future<void> removeFromFavourites(int songId) async {
    final dbClient = await db.database;
    await dbClient.delete(
      'favourites',
      where: 'song_id = ?',
      whereArgs: [songId],
    );
  }

  Future<List<int>> getFavouriteSongs() async {
    final dbClient = await db.database;
    final maps = await dbClient.query('favourites');
    return maps.map((e) => e['song_id'] as int).toList();
  }

  Future<bool> isFavourite(int songId) async {
    final dbClient = await db.database;
    final maps = await dbClient.query(
      'favourites',
      where: 'song_id = ?',
      whereArgs: [songId],
    );
    return maps.isNotEmpty;
  }

  // Recent plays
  Future<void> addRecentPlay(int songId) async {
    final dbClient = await db.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await dbClient.insert('recent_plays', {
      'song_id': songId,
      'played_at': now,
    });
  }

  Future<List<int>> getRecentPlays({int limit = 20}) async {
    final dbClient = await db.database;
    final maps = await dbClient.query(
      'recent_plays',
      orderBy: 'played_at DESC',
      limit: limit,
    );
    return maps.map((e) => e['song_id'] as int).toList();
  }
}
