// lib/screens/player/full_player_screen.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:swaralipi/services/global_audio_service.dart';

class FullPlayerScreen extends StatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Start rotation if playing
    final audioService = GlobalAudioService();
    if (audioService.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GlobalAudioService(),
      builder: (context, child) {
        final audioService = GlobalAudioService();

        // Control rotation based on play state
        if (audioService.isPlaying && !_rotationController.isAnimating) {
          _rotationController.repeat();
        } else if (!audioService.isPlaying && _rotationController.isAnimating) {
          _rotationController.stop();
        }

        if (audioService.currentSong == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: const Center(
              child: Text(
                'No song playing',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.withOpacity(0.3),
                  Colors.black,
                  Colors.black,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Now Playing',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${audioService.currentIndex + 1} of ${audioService.playlist.length}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Show more options
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Album Art
                  GestureDetector(
                    onTap: () {
                      _scaleController.forward().then((_) {
                        _scaleController.reverse();
                      });
                    },
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _rotationController,
                        _scaleController,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_scaleController.value * 0.05),
                          child: Transform.rotate(
                            angle: _rotationController.value * 2 * math.pi,
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.6),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: QueryArtworkWidget(
                                  id: audioService.currentSong!.id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.deepPurple[300]!,
                                          Colors.deepPurple[700]!,
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  // Song Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          audioService.currentSong!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          audioService.currentSong!.artist ?? "Unknown Artist",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.deepPurpleAccent,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.white,
                            overlayColor: Colors.deepPurpleAccent.withOpacity(
                              0.2,
                            ),
                            trackHeight: 4.0,
                          ),
                          child: Slider(
                            value: audioService.duration.inSeconds > 0
                                ? audioService.position.inSeconds.toDouble()
                                : 0.0,
                            max: audioService.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              audioService.seek(
                                Duration(seconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                audioService.formatDuration(
                                  audioService.position,
                                ),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                audioService.formatDuration(
                                  audioService.duration,
                                ),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Control Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Shuffle
                        IconButton(
                          onPressed: () => audioService.toggleShuffle(),
                          icon: Icon(
                            Icons.shuffle,
                            color: audioService.isShuffled
                                ? Colors.deepPurpleAccent
                                : Colors.grey[600],
                            size: 28,
                          ),
                        ),

                        // Previous
                        IconButton(
                          onPressed: audioService.hasPrevious
                              ? () => audioService.playPrevious()
                              : null,
                          icon: Icon(
                            Icons.skip_previous,
                            color: audioService.hasPrevious
                                ? Colors.white
                                : Colors.grey[600],
                            size: 36,
                          ),
                        ),

                        // Play/Pause
                        GestureDetector(
                          onTap: () => audioService.togglePlayPause(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: audioService.isPlaying
                                  ? Colors.white
                                  : Colors.deepPurpleAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurpleAccent.withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: audioService.isBuffering
                                ? const CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
                                  )
                                : Icon(
                                    audioService.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: audioService.isPlaying
                                        ? Colors.black
                                        : Colors.white,
                                    size: 40,
                                  ),
                          ),
                        ),

                        // Next
                        IconButton(
                          onPressed: audioService.hasNext
                              ? () => audioService.playNext()
                              : null,
                          icon: Icon(
                            Icons.skip_next,
                            color: audioService.hasNext
                                ? Colors.white
                                : Colors.grey[600],
                            size: 36,
                          ),
                        ),

                        // Repeat
                        IconButton(
                          onPressed: () => audioService.toggleRepeatMode(),
                          icon: Icon(
                            audioService.repeatMode == RepeatMode.one
                                ? Icons.repeat_one
                                : Icons.repeat,
                            color: audioService.repeatMode != RepeatMode.off
                                ? Colors.deepPurpleAccent
                                : Colors.grey[600],
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
