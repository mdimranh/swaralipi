import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void showCreatePlaylistModal(BuildContext context) {
  final TextEditingController _controller = TextEditingController();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white.withAlpha(120),
      title: const Text(
        "Create Playlist",
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: Colors.black45),
        decoration: const InputDecoration(
          hintText: "Playlist name",
          hintStyle: TextStyle(color: Colors.black45),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withAlpha(100),
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            final playlistName = _controller.text.trim();
            if (playlistName.isEmpty) return;

            final result = await _audioQuery.createPlaylist(playlistName);

            Navigator.of(context).pop(); // Close dialog

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result
                      ? "Playlist '$playlistName' created!"
                      : "Failed to create playlist.",
                ),
              ),
            );
          },
          child: const Text("Create"),
        ),
      ],
    ),
  );
}
