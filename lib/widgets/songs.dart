import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final List<Map<String, dynamic>> songs = [
    {
      'title': 'Song 1',
      'artist': 'Artist 1',
      'duration': '3:45',
      'album': 'Album 1',
      'image': 'assets/images/bg2.jpg',
    },
    {
      'title': 'Song 2',
      'artist': 'Artist 2',
      'duration': '4:30',
      'album': 'Album 2',
      'image': 'assets/images/bg3.jpg',
    },
    {
      'title': 'Song 3',
      'artist': 'Artist 3',
      'duration': '2:15',
      'album': 'Album 3',
      'image': 'assets/images/bg4.jpg',
    },
    {
      'title': 'Song 4',
      'artist': 'Artist 4',
      'duration': '3:30',
      'album': 'Album 4',
      'image': 'assets/images/bg1.jpg',
    },
    {
      'title': 'Song 5',
      'artist': 'Artist 5',
      'duration': '2:45',
      'album': 'Album 5',
      'image': 'assets/images/bg2.jpg',
    },
    {
      'title': 'Song 6',
      'artist': 'Artist 6',
      'duration': '3:15',
      'album': 'Album 6',
      'image': 'assets/images/bg3.jpg',
    },
    {
      'title': 'Song 7',
      'artist': 'Artist 7',
      'duration': '4:00',
      'album': 'Album 7',
      'image': 'assets/images/bg4.jpg',
    },
    {
      'title': 'Song 8',
      'artist': 'Artist 8',
      'duration': '2:30',
      'album': 'Album 8',
      'image': 'assets/images/bg1.jpg',
    },
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // ✅ Expand to take remaining screen height
      child: Card(
        color: Colors.white.withAlpha(70),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Top row (Sort + Shuffle + Play buttons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sort_sharp,
                        color: Colors.white.withAlpha(180),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "Name",
                        style: TextStyle(color: Colors.white.withAlpha(180)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _circleIcon(Icons.shuffle),
                      const SizedBox(width: 15),
                      _circleIcon(Icons.play_arrow),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // ✅ Flexible ListView (scrollable only if overflow)
              Expanded(
                child: ListView.separated(
                  itemCount: songs.length,
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
                              child: Image.asset(
                                songs[i]['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  songs[i]['title'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  songs[i]['artist'],
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(120),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              songs[i]['duration'],
                              style: TextStyle(
                                color: Colors.white.withAlpha(160),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white.withAlpha(180)),
    );
  }
}
