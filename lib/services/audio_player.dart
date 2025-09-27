// import 'package:just_audio/just_audio.dart';

// class AudioPlayerService {
//   final AudioPlayer _player = AudioPlayer();

//   Stream<PlayerState> get playerStateStream => _player.playerStateStream;
//   Stream<Duration?> get durationStream => _player.durationStream;
//   Stream<Duration> get positionStream => _player.positionStream;

//   Future<void> setSong(String uri) async {
//     await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
//   }

//   Future<void> play() => _player.play();
//   Future<void> pause() => _player.pause();
//   Future<void> stop() => _player.stop();

//   Future<void> seek(Duration position) => _player.seek(position);

//   void dispose() {
//     _player.dispose();
//   }
// }

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  // Singleton pattern (so you can use it globally)
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  // 🎵 Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  // 🎵 Load a single song
  Future<void> setSong(String uri) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
  }

  // 🎵 Load a playlist
  Future<void> setPlaylist(List<String> uris, {int initialIndex = 0}) async {
    final playlist = ConcatenatingAudioSource(
      children: uris.map((uri) => AudioSource.uri(Uri.parse(uri))).toList(),
    );
    await _player.setAudioSource(playlist, initialIndex: initialIndex);
  }

  // ▶️ Controls
  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> seekToIndex(int index) =>
      _player.seek(Duration.zero, index: index);

  // ⏭️ Skip
  Future<void> next() => _player.seekToNext();
  Future<void> previous() => _player.seekToPrevious();

  // 🔁 Loop & Shuffle
  void setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  void setShuffleModeEnabled(bool enabled) =>
      _player.setShuffleModeEnabled(enabled);

  // ❌ Dispose
  void dispose() {
    _player.dispose();
  }

  AudioPlayer get rawPlayer => _player;
}
