// lib/widgets/app_wrapper.dart

import 'package:flutter/material.dart';
import 'package:swaralipi/services/global_audio_service.dart';
import 'package:swaralipi/widgets/player/mini_player.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Main content - use Expanded here properly inside Column
          Expanded(child: child),

          // Mini player at the bottom
          AnimatedBuilder(
            animation: GlobalAudioService(),
            builder: (context, child) {
              final audioService = GlobalAudioService();

              // Only show mini player if there's a current song
              final showMiniPlayer = audioService.currentSong != null;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: showMiniPlayer ? 80 : 0,
                child: showMiniPlayer
                    ? const MiniPlayer()
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
