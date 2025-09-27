// lib/services/global_audio_service.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  SongModel? _currentSong;
  List<SongModel> _playlist = [];
  int _currentIndex = 0;

  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Repeat modes: none, one, all
  RepeatMode _repeatMode = RepeatMode.off;
  bool _isShuffled = false;
  List<int> _shuffledIndices = [];

  // Getters
  SongModel? get currentSong => _currentSong;
  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  Duration get duration => _duration;
  Duration get position => _position;
  RepeatMode get repeatMode => _repeatMode;
  bool get isShuffled => _isShuffled;
  bool get hasNext => _isShuffled
      ? _currentIndex < _shuffledIndices.length - 1
      : _currentIndex < _playlist.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  // Initialize streams
  void init() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isBuffering = state.processingState == ProcessingState.buffering;
      notifyListeners();
    });

    _player.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    _player.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Auto play next song when current ends
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_repeatMode == RepeatMode.one) {
          _player.seek(Duration.zero);
          _player.play();
        } else {
          playNext();
        }
      }
    });
  }

  // Play a single song
  Future<void> playSong(
    SongModel song, {
    List<SongModel>? playlist,
    int? index,
  }) async {
    try {
      if (playlist != null) {
        _playlist = playlist;
        _currentIndex = index ?? 0;
        _generateShuffledIndices();
      } else {
        _playlist = [song];
        _currentIndex = 0;
        _shuffledIndices = [0];
      }

      _currentSong = song;
      await _player.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  // Play next song
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    int nextIndex;
    if (_isShuffled) {
      if (_currentIndex < _shuffledIndices.length - 1) {
        nextIndex = _shuffledIndices[_currentIndex + 1];
        _currentIndex++;
      } else if (_repeatMode == RepeatMode.all) {
        _currentIndex = 0;
        nextIndex = _shuffledIndices[0];
      } else {
        return;
      }
    } else {
      if (_currentIndex < _playlist.length - 1) {
        _currentIndex++;
        nextIndex = _currentIndex;
      } else if (_repeatMode == RepeatMode.all) {
        _currentIndex = 0;
        nextIndex = 0;
      } else {
        return;
      }
    }

    _currentSong = _playlist[nextIndex];
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(_currentSong!.uri!)),
    );
    await _player.play();
    notifyListeners();
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_playlist.isEmpty || _currentIndex == 0) return;

    int prevIndex;
    if (_isShuffled) {
      prevIndex = _shuffledIndices[_currentIndex - 1];
    } else {
      prevIndex = _currentIndex - 1;
    }

    _currentIndex--;
    _currentSong = _playlist[prevIndex];
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(_currentSong!.uri!)),
    );
    await _player.play();
    notifyListeners();
  }

  // Seek to position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // Toggle repeat mode
  void toggleRepeatMode() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }

  // Toggle shuffle
  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _generateShuffledIndices();
    }
    notifyListeners();
  }

  // Generate shuffled indices
  void _generateShuffledIndices() {
    _shuffledIndices = List.generate(_playlist.length, (index) => index);
    if (_currentSong != null) {
      final currentSongIndex = _playlist.indexWhere(
        (song) => song.id == _currentSong!.id,
      );
      if (currentSongIndex != -1) {
        _shuffledIndices.remove(currentSongIndex);
        _shuffledIndices.shuffle();
        _shuffledIndices.insert(0, currentSongIndex);
        _currentIndex = 0;
      }
    } else {
      _shuffledIndices.shuffle();
    }
  }

  // Format duration
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

enum RepeatMode { off, one, all }
