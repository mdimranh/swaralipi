import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatefulWidget {
  final SongModel song;

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(widget.song.uri!)),
      );
      _player.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
      _rotationController.stop();
    } else {
      _player.play();
      _rotationController.repeat();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.song.title, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Rotating album art
            AnimatedBuilder(
              animation: _rotationController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: QueryArtworkWidget(
                  id: widget.song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const CircleAvatar(
                    radius: 125,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  artworkBorder: BorderRadius.circular(200),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Song Info
            Text(
              widget.song.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.song.artist ?? "Unknown Artist",
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),

            const SizedBox(height: 30),

            // Progress Bar
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _player.duration ?? Duration.zero;

                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      activeColor: Colors.deepPurpleAccent,
                      inactiveColor: Colors.grey[700],
                      onChanged: (value) {
                        _player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const Spacer(),

            // Play Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 50,
                  onPressed: () {}, // hook next/prev
                ),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? Colors.deepPurpleAccent
                          : Colors.greenAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  iconSize: 50,
                  onPressed: () {}, // hook next/prev
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
