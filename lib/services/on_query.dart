import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();

Future<bool> requestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}

Future<List<SongModel>> fetchSongs() async {
  bool permission = await requestPermissions();
  if (!permission) return [];
  return await _audioQuery.querySongs();
}

Future<List<AlbumModel>> fetchAlbums() async {
  return await _audioQuery.queryAlbums();
}

Future<List<ArtistModel>> fetchArtists() async {
  return await _audioQuery.queryArtists();
}
