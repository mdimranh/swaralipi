// lib/widgets/mini_player.dart

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:swaralipi/screens/player/full_player_screen.dart';
import 'package:swaralipi/services/global_audio_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GlobalAudioService(),
      builder: (context, child) {
        final audioService = GlobalAudioService();

        if (audioService.currentSong == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FullPlayerScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Album Art
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: QueryArtworkWidget(
                          id: audioService.currentSong!.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            color: Colors.deepPurple[200],
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Song Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            audioService.currentSong!.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            audioService.currentSong!.artist ??
                                "Unknown Artist",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Progress Indicator
                    if (audioService.duration.inSeconds > 0)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  value:
                                      audioService.position.inSeconds /
                                      audioService.duration.inSeconds,
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepPurpleAccent,
                                  ),
                                  backgroundColor: Colors.grey[700],
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => audioService.togglePlayPause(),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    audioService.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Next button
                    IconButton(
                      onPressed: audioService.hasNext
                          ? () => audioService.playNext()
                          : null,
                      icon: Icon(
                        Icons.skip_next,
                        color: audioService.hasNext
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
