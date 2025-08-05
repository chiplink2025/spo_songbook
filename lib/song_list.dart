import 'package:flutter/material.dart';
import 'song.dart';
import 'song_page.dart';

class SongListScreen extends StatefulWidget {
  final List<Song> songs;

  const SongListScreen({Key? key, required this.songs}) : super(key: key);

  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late List<Song> filteredSongs;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredSongs = List.from(widget.songs)
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredSongs =
          widget.songs
              .where(
                (song) =>
                    song.title.toLowerCase().contains(searchQuery) ||
                    song.lyrics.toLowerCase().contains(searchQuery) ||
                    song.number.toString().contains(searchQuery),
              )
              .toList()
            ..sort((a, b) => a.title.compareTo(b.title));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPO Songbook')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return ListTile(
                  title: Text('${song.number}. ${song.title}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongPage(song: song),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
