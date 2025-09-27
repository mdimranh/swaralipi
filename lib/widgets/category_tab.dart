import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  final int totalSongs;
  final int totalAlbums;
  final int totalArtists;
  final int totalPlaylists;
  final int totalGenres;
  // onChangeActive callback
  final void Function(String tab) onChangeActive;

  const CategoryTabs({
    Key? key,
    required this.totalSongs,
    required this.totalAlbums,
    required this.totalArtists,
    required this.totalPlaylists,
    required this.totalGenres,
    required this.onChangeActive,
  }) : super(key: key);

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  final List<String> tabs = [
    "Playlists",
    "Favourites",
    "Songs",
    "Albums",
    "Artists",
    "Genres",
  ];
  int selected = 2;

  late final List<GlobalKey> keys = List.generate(
    tabs.length,
    (_) => GlobalKey(),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length * 2 - 1, (i) {
        if (i.isOdd) return const SizedBox(width: 8);
        final index = i ~/ 2;
        final isSelected = selected == index;

        // Prepare the count text based on tab index
        String countText = '';
        switch (tabs[index]) {
          case 'Songs':
            if (widget.totalSongs > 0) {
              countText = widget.totalSongs.toString();
            }
            break;
          case 'Artists':
            if (widget.totalArtists > 0) {
              countText = widget.totalArtists.toString();
            }
            break;
          case 'Albums':
            if (widget.totalAlbums > 0) {
              countText = widget.totalAlbums.toString();
            }
            break;
          case 'Playlists':
            if (widget.totalPlaylists > 0) {
              countText = widget.totalPlaylists.toString();
            }
          case "Genres":
            if (widget.totalGenres > 0) {
              countText = widget.totalGenres.toString();
            }
            break;
          default:
            countText = ''; // No count for other tabs
        }

        return GestureDetector(
          onTap: () {
            widget.onChangeActive(tabs[index]);
            setState(() => selected = index);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final keyContext = keys[index].currentContext;
              if (keyContext != null) {
                Scrollable.ensureVisible(
                  keyContext,
                  duration: const Duration(milliseconds: 300),
                  alignment: 0.5,
                  curve: Curves.easeInOut,
                );
              }
            });
          },
          child: Container(
            key: keys[index],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withAlpha(50)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (countText.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      countText,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
