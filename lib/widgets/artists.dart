import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:swaralipi/widgets/viewer_card.dart';

class ArtistList extends StatefulWidget {
  final List<ArtistModel> artists;
  const ArtistList({super.key, required this.artists});

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return ViewCard(
      showEmpty: widget.artists.isEmpty,
      emptytitle: "No Artists Found",
      emptyMessage: "You don't have any artist",
      header: ViewCardHeader(
        actions: [ViewCardAction(icon: Icons.info_outline, onPressed: () {})],
      ),
      body: ListView.separated(
        itemCount: widget.artists.length,
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
                      id: widget.artists[i].id,
                      type: ArtworkType.ARTIST,
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
                          widget.artists[i].artist.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.artists[i].numberOfAlbums} Albums | ${widget.artists[i].numberOfTracks} Songs',
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
