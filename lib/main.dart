import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swaralipi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Swaralipi'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background
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

          // ✅ Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Logo + App Name
                  Flex(
                    direction: Axis.horizontal,
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
                            icon: const Icon(Icons.search, color: Colors.white),
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
                  // const SizedBox(height: 20),

                  // Search Bar
                  // TextField(
                  //   textAlignVertical: TextAlignVertical.center,
                  //   style: const TextStyle(color: Colors.white),
                  //   decoration: InputDecoration(
                  //     hintText: "Search",
                  //     hintStyle: TextStyle(
                  //       color: Colors.white.withOpacity(0.7),
                  //     ),
                  //     prefixIcon: const Icon(Icons.search, color: Colors.white),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     fillColor: Colors.white.withAlpha(50),
                  //     filled: true,
                  //   ),
                  // ),
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
                      child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: CategoryTabs(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ✅ Song list expands dynamically
                  const SongList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  final List<String> tabs = [
    "Tracks",
    "Artists",
    "Albums",
    "Favourites",
    "Playlists",
  ];
  int selected = 0;

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

        return GestureDetector(
          onTap: () {
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
            child: Text(
              tabs[index],
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

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
      'image': 'assets/images/bg2.jpg',
    },
    {
      'title': 'Song 2',
      'artist': 'Artist 2',
      'duration': '4:30',
      'image': 'assets/images/bg3.jpg',
    },
    {
      'title': 'Song 3',
      'artist': 'Artist 3',
      'duration': '2:15',
      'image': 'assets/images/bg4.jpg',
    },
    {
      'title': 'Song 4',
      'artist': 'Artist 4',
      'duration': '3:30',
      'image': 'assets/images/bg1.jpg',
    },
    {
      'title': 'Song 5',
      'artist': 'Artist 5',
      'duration': '2:45',
      'image': 'assets/images/bg2.jpg',
    },
    {
      'title': 'Song 6',
      'artist': 'Artist 6',
      'duration': '3:15',
      'image': 'assets/images/bg3.jpg',
    },
    {
      'title': 'Song 1',
      'artist': 'Artist 1',
      'duration': '3:45',
      'image': 'assets/images/bg2.jpg',
    },
    {
      'title': 'Song 2',
      'artist': 'Artist 2',
      'duration': '4:30',
      'image': 'assets/images/bg3.jpg',
    },
    {
      'title': 'Song 3',
      'artist': 'Artist 3',
      'duration': '2:15',
      'image': 'assets/images/bg4.jpg',
    },
    {
      'title': 'Song 4',
      'artist': 'Artist 4',
      'duration': '3:30',
      'image': 'assets/images/bg1.jpg',
    },
    {
      'title': 'Song 5',
      'artist': 'Artist 5',
      'duration': '2:45',
      'image': 'assets/images/bg2.jpg',
    },
    {
      'title': 'Song 6',
      'artist': 'Artist 6',
      'duration': '3:15',
      'image': 'assets/images/bg3.jpg',
    },
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white.withAlpha(70),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Header row (sort, shuffle, play)
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

              // Scrollable list
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
