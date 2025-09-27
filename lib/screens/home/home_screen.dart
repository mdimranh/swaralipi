// lib/screens/home/home_screen.dart (Fixed layout issues)

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:swaralipi/services/global_audio_service.dart';
import 'package:swaralipi/widgets/albums.dart';
import 'package:swaralipi/widgets/artists.dart';
import 'package:swaralipi/widgets/category_tab.dart';
import 'package:swaralipi/widgets/favourites.dart';
import 'package:swaralipi/widgets/genres.dart';
import 'package:swaralipi/widgets/playlist/playlists.dart';
import 'package:swaralipi/widgets/songs.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final GlobalAudioService _audioService = GlobalAudioService();

  String _activeTab = 'Songs';

  List<SongModel> _songs = [];
  List<PlaylistModel> _playlists = [];
  List<AlbumModel> _albums = [];
  List<ArtistModel> _artists = [];
  List<GenreModel> _genres = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndLoadSongs();
  }

  Future<void> _requestPermissionsAndLoadSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      permissionStatus = await _audioQuery.permissionsRequest();
    }
    if (permissionStatus) {
      final songs = await _audioQuery.querySongs();
      final albums = await _audioQuery.queryAlbums();
      final artists = await _audioQuery.queryArtists();
      final playlists = await _audioQuery.queryPlaylists();
      final genres = await _audioQuery.queryGenres();
      setState(() {
        _songs = songs;
        _albums = albums;
        _artists = artists;
        _playlists = playlists;
        _genres = genres;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                opacity: 0.8,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Logo + App Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/logo.png', width: 50),
                              const SizedBox(width: 10),
                              Text(
                                "Swaralipi",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withAlpha(200),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Tabs
                      SizedBox(
                        height: 50,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white,
                                Colors.white,
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.05, 0.95, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CategoryTabs(
                              onChangeActive: (tab) =>
                                  setState(() => _activeTab = tab),
                              totalSongs: _songs.length,
                              totalAlbums: _albums.length,
                              totalArtists: _artists.length,
                              totalPlaylists: _playlists.length,
                              totalGenres: _genres.length,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                // Content area - properly use Expanded within Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildActiveTabContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 'Songs':
        return SongList(
          songs: _songs,
          onSongTap: (song, songs, index) {
            _audioService.playSong(song, playlist: songs, index: index);
          },
        );
      case 'Albums':
        return AlbumList(albums: _albums);
      case 'Artists':
        return ArtistList(artists: _artists);
      case 'Playlists':
        return PlayList(playlists: _playlists);
      case 'Favourites':
        return FavouriteList(favourites: []);
      case 'Genres':
        return GenreList(genres: _genres);
      default:
        return SongList(
          songs: _songs,
          onSongTap: (song, songs, index) {
            _audioService.playSong(song, playlist: songs, index: index);
          },
        );
    }
  }
}
