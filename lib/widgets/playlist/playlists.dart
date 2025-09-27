import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:swaralipi/widgets/playlist/create_playlist.dart';
import 'package:swaralipi/widgets/viewer_card.dart';

class PlayList extends StatefulWidget {
  final List<PlaylistModel> playlists;
  const PlayList({super.key, required this.playlists});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return ViewCard(
      showEmpty: widget.playlists.isEmpty,
      emptytitle: "No Playlist Found",
      emptyMessage: "You don't create any playlist yet",
      header: ViewCardHeader(
        actions: [
          ViewCardAction(
            icon: Icons.add,
            onPressed: () => showCreatePlaylistModal(context),
          ),
          ViewCardAction(icon: Icons.info_outline, onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: widget.playlists.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.white.withAlpha(30)),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => setState(() => selected = i),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QueryArtworkWidget(
                      id: widget.playlists[i].id,
                      type: ArtworkType.PLAYLIST,
                      artworkBorder: BorderRadius
                          .zero, // since you're already using ClipRRect
                      nullArtworkWidget: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: Icon(Icons.music_note, color: Colors.white),
                      ),
                      artworkHeight: 50,
                      artworkWidth: 50,
                      artworkFit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlists[i].playlist.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.playlists[i].numOfSongs} Songs',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withAlpha(120)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
